import 'package:dio/dio.dart';
import 'package:e_sport/data/model/chat_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/di/dependency_injection.dart';
import 'package:get/get.dart';
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
    print("chat data:" + response.data.toString());
    chats.assignAll((response.data['data'] as List?)
            ?.map((e) => ChatModel.fromJson(e))
            .toList() ??
        []);

    // await db.insertChats();
    // } catch (err) {
    //   Get.log("chat retrieving error" + err.toString());
    // }
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
            chatSlug: json['chat']["user"]["slug"],
            createdAt: DateTime.parse(item["sent_at"]),
            senderName: item['sender']['full_name'] ??
                json['chat']['user']['full_name'],
            senderSlug: item['sender']['slug'] ?? json['chat']['user']['slug'],
            senderImage: item['sender']['profile']?['profile_picture'] ??
                json['chat']['user']['profile']['profile_picture'],
            isRead: (item['read_by'] as List).isNotEmpty))
        .toList();
    await db.insertChat(chat);
    await db.insertMessages(messages);
    // } catch (err) {
    //   print(err.toString());
    // }
  }

  Future connectToWebSocket(String username) async {
    print("connecting to websocket");
    try {
      final authController = Get.find<AuthRepository>();
      channel = IOWebSocketChannel.connect(
          Uri.parse(ApiLink.webSocketUrl(username, authController.token)),
          headers: {"Origin": "wss://api.engy.africa"});
      isConnected.value = true;
      channel?.stream.listen((message) {
        print("WebSocket Message: $message");
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
