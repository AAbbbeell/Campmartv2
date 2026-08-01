import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final int id;
  final String message;
  final String? attachmentUrl;
  final int senderId;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.message,
    this.attachmentUrl,
    required this.senderId,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable()
class Conversation {
  final int id;
  final OtherUser otherUser;
  final LastMessage? lastMessage;
  final int unreadCount;
  final ConversationProduct? product;
  final ConversationService? service;
  final DateTime lastMessageAt;
  final DateTime createdAt;

  Conversation({
    required this.id,
    required this.otherUser,
    this.lastMessage,
    required this.unreadCount,
    this.product,
    this.service,
    required this.lastMessageAt,
    required this.createdAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}

@JsonSerializable()
class OtherUser {
  final int id;
  final String fullName;
  final String username;
  final String? profileImage;

  OtherUser({
    required this.id,
    required this.fullName,
    required this.username,
    this.profileImage,
  });

  factory OtherUser.fromJson(Map<String, dynamic> json) =>
      _$OtherUserFromJson(json);

  Map<String, dynamic> toJson() => _$OtherUserToJson(this);
}

@JsonSerializable()
class LastMessage {
  final String message;
  final int senderId;
  final DateTime createdAt;

  LastMessage({
    required this.message,
    required this.senderId,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) =>
      _$LastMessageFromJson(json);

  Map<String, dynamic> toJson() => _$LastMessageToJson(this);
}

@JsonSerializable()
class ConversationProduct {
  final int id;
  final String title;
  final String? image;

  ConversationProduct({
    required this.id,
    required this.title,
    this.image,
  });

  factory ConversationProduct.fromJson(Map<String, dynamic> json) =>
      _$ConversationProductFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationProductToJson(this);
}

@JsonSerializable()
class ConversationService {
  final int id;
  final String title;

  ConversationService({
    required this.id,
    required this.title,
  });

  factory ConversationService.fromJson(Map<String, dynamic> json) =>
      _$ConversationServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationServiceToJson(this);
}
