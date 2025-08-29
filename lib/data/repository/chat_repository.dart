import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_sport/data/model/chat_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/di/dependency_injection.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:e_sport/data/db/chat_database.dart';

var storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
  encryptedSharedPreferences: true,
));

class ChatRepository extends GetxController {
  final ChatDatabase db = ChatDatabase.instance;
  final authController = Get.find<AuthRepository>();

  RxBool messageOnSelect = false.obs;
  RxBool archiveOnSelect = false.obs;
  late Dio _dio;
  RxBool loadingChats = true.obs;
  RxList<ChatModel> chats = RxList([]);
  WebSocketChannel? channel;
  RxBool isConnected = false.obs;

  @override
  void onInit() async {
    final dio = Get.find<ApiService>().dio;
    _dio = dio;

    // Reset database during development to fix schema issues
    // Set this to false after the first successful run
    const bool resetDatabaseForDevelopment = true;
    if (resetDatabaseForDevelopment) {
      // await ChatDao.resetDatabase();
    }

    getUserChats();
    super.onInit();
  }

  Future getUserChats() async {
    loadingChats.value = true;
    // try {
    final response = await _dio.get(ApiLink.getUserChats);
    print("all chat data:" + response.data.toString());
    loadingChats.value = false;
  }

  Future getChatHistory(String username) async {
    // try {
    final response = await _dio.get(ApiLink.getChatHistory(username));
    var json = response.data['data'];
    Chat chat = Chat(
        name: json['chat']['user']['full_name'],
        lastMessageSlug: json['results'][0]['slug'],
        slug: json['chat']['user']['slug'],
        username: json['chat']['user']['user_name'],
        image: json['chat']['user']['profile']['profile_picture']);
    List<Message> messages = (json["results"] as List<dynamic>)
        .map((item) => Message(
            content: item["text"],
            slug: item["slug"],
            status: "sent",
            imageUrls: item['images'] != null
                ? jsonEncode((item['images'] as List<dynamic>)
                    .map((item) => item['url'])
                    .toList())
                : null,
            chatSlug: json['chat']["user"]["slug"],
            createdAt: DateTime.parse(item["sent_at"]),
            senderName: item['user']['full_name'],
            senderSlug: item['user']['slug'],
            senderImage: item['user']['profile']['profile_picture'],
            isRead: (item['read_by'] as List).isNotEmpty))
        .toList();
    await db.insertChat(chat);
    await db.insertMessages(messages);
    var pendingMessages =
        await db.getPendingMessages(json['chat']['user']['slug']);
    // Send any pending messages that were stored while offline
    for (var message in pendingMessages) {
      if (channel != null && isConnected.value) {
        final payload = {
          "message": message.content,
          "slug": message.slug,
          "user_id": authController.user?.id,
          "user_name": authController.user?.userName!,
          "message_type": "text",
          "read_by": [],
          "url":
              message.imageUrls != null ? jsonDecode(message.imageUrls!) : [],
          "reply_to": {
            "message": null,
            "slug": null,
            "user_id": null,
            "user_name": null,
            "message_type": "text",
            "read_by": [],
            "url": []
          }
        };

        try {
          channel?.sink.add(jsonEncode(payload));
          // Update message status to sent
          await db.insertMessage(message.copyWith(status: 'sent'));
        } catch (e) {
          print("Error sending pending message: $e");
        }
      }
    }
    // } catch (err) {
    //   print(err.toString());
    // }
  }

  Future connectToWebSocket(String username, String chatSlug) async {
    print("connecting to websocket");
    try {
      final authController = Get.find<AuthRepository>();
      channel = IOWebSocketChannel.connect(
          Uri.parse(ApiLink.webSocketUrl(username, authController.token)),
          headers: {"Origin": "wss://api.engy.africa"});
      isConnected.value = true;
      channel?.stream.listen((message) async {
        var json = jsonDecode(message);
        if (json['message'] == null) return;
        await db.insertMessage(Message(
            slug: json['slug'],
            chatSlug: chatSlug,
            content: json["message"],
            senderName: json['user_name'],
            senderSlug: json['user_slug'],
            status: "sent",
            createdAt: DateTime.parse(json['timestamp']),
            isRead: false));
        await db.updateLastMessage(chatSlug, json['slug']);
      }, onError: (error) {
        isConnected.value = false;
        print("WebSocket error: $error");
      }, onDone: () {
        isConnected.value = false;
        print("WebSocket closed");
      });
    } catch (e) {
      isConnected.value = false;
      print("WebSocket exception: $e");
    }
  }

  Future<void> sendMessage({
    required String message,
    required String chatSlug,
    List<String>? imageUrls,
    String? replyToSlug,
  }) async {
    var uuid = Uuid();
    var slug = uuid.v4().toString();
    Message record = Message(
        content: message,
        slug: slug,
        status: "pending",
        imageUrls: imageUrls != null ? jsonEncode(imageUrls) : null,
        chatSlug: chatSlug,
        createdAt: DateTime.now(),
        senderName: authController.user!.fullName!,
        senderSlug: authController.user?.slug,
        senderImage: authController.user?.profile?.profilePicture,
        isRead: false);
    await db.insertMessage(record);
    if (!isConnected.value || channel == null) {
      print("WebSocket not connected");
      return;
    }

    final payload = {
      "message": message,
      "slug": slug,
      "user_id": authController
          .user?.id, // Should be dynamically set based on current user
      "user_name": authController.user?.userName!,
      "message_type": "text",
      "read_by": [],
      // "timestamp": DateTime.now().toUtc().toIso8601String(),
      "url": imageUrls ?? [],
      "reply_to": {
        "message": null,
        "slug": replyToSlug,
        "user_id": null,
        "user_name": null,
        "message_type": "text",
        "read_by": [],
        "url": []
      }
    };

    try {
      channel?.sink.add(jsonEncode(payload));
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  void disconnectFromWebSocket() {
    channel?.sink.close();
    isConnected.value = false;
    channel = null;
  }

  Stream<List<Message>> watchMessages(String slug) {
    return db.watchMessages(slug);
  }

  Stream<List<Chat>> watchChats() {
    return db.watchChats();
  }

  Future<Message> getMessage(String slug) async {
    return await db.getMessage(slug);
  }

  Stream<Message?> getLastMessage(String chatSlug) {
    return db.watchLastMessage(chatSlug);
  }

  Future<Chat> getChat(String slug) async {
    return await db.getChat(slug);
  }

  Future<String?> getCurrentUserSlug() async {
    try {
      final authController = Get.find<AuthRepository>();
      return authController.user?.slug;
    } catch (e) {
      print("Error getting current username: $e");
      return null;
    }
  }
}
