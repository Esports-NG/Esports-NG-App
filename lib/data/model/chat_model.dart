import 'package:e_sport/data/model/user_model.dart';

class ChatModel {
  final String slug;
  final UserModel user;
  final String chatType;
  // final MessageModel? lastMessage;
  final String createdAt;

  ChatModel({
    required this.slug,
    required this.user,
    required this.chatType,
    // required this.lastMessage,
    required this.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      slug: json['slug'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      chatType: json['chat_type'] as String,
      // lastMessage: json['last_message'] == null
      //     ? null
      //     : MessageModel.fromJson(json['last_message'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'user': user.toJson(),
      'chat_type': chatType,
      // 'last_message': lastMessage?.toJson(),
      'created_at': createdAt,
    };
  }
}

class ProfileModel {
  final String? profilePicture;

  ProfileModel({
    this.profilePicture,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profilePicture: json['profile_picture'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_picture': profilePicture,
    };
  }
}

class MessageModel {
  final int id;
  final int user;
  final String text;
  final List<dynamic> readBy;
  final dynamic replyTo;
  final List<dynamic> images;
  final String sentAt;

  MessageModel({
    required this.id,
    required this.user,
    required this.text,
    required this.readBy,
    required this.replyTo,
    required this.images,
    required this.sentAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      user: json['user'] as int,
      text: json['text'] as String,
      readBy: json['read_by'] as List<dynamic>,
      replyTo: json['reply_to'],
      images: json['images'] as List<dynamic>,
      sentAt: json['sent_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'text': text,
      'read_by': readBy,
      'reply_to': replyTo,
      'images': images,
      'sent_at': sentAt,
    };
  }
}
