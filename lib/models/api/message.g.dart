// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  id: (json['id'] as num).toInt(),
  message: json['message'] as String,
  attachmentUrl: json['attachmentUrl'] as String?,
  senderId: (json['senderId'] as num).toInt(),
  isRead: json['isRead'] as bool,
  readAt: json['readAt'] == null
      ? null
      : DateTime.parse(json['readAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'id': instance.id,
  'message': instance.message,
  'attachmentUrl': instance.attachmentUrl,
  'senderId': instance.senderId,
  'isRead': instance.isRead,
  'readAt': instance.readAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
};

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
  id: (json['id'] as num).toInt(),
  otherUser: OtherUser.fromJson(json['otherUser'] as Map<String, dynamic>),
  lastMessage: json['lastMessage'] == null
      ? null
      : LastMessage.fromJson(json['lastMessage'] as Map<String, dynamic>),
  unreadCount: (json['unreadCount'] as num).toInt(),
  product: json['product'] == null
      ? null
      : ConversationProduct.fromJson(json['product'] as Map<String, dynamic>),
  service: json['service'] == null
      ? null
      : ConversationService.fromJson(json['service'] as Map<String, dynamic>),
  lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'otherUser': instance.otherUser,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'product': instance.product,
      'service': instance.service,
      'lastMessageAt': instance.lastMessageAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

OtherUser _$OtherUserFromJson(Map<String, dynamic> json) => OtherUser(
  id: (json['id'] as num).toInt(),
  fullName: json['fullName'] as String,
  username: json['username'] as String,
  profileImage: json['profileImage'] as String?,
);

Map<String, dynamic> _$OtherUserToJson(OtherUser instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'username': instance.username,
  'profileImage': instance.profileImage,
};

LastMessage _$LastMessageFromJson(Map<String, dynamic> json) => LastMessage(
  message: json['message'] as String,
  senderId: (json['senderId'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$LastMessageToJson(LastMessage instance) =>
    <String, dynamic>{
      'message': instance.message,
      'senderId': instance.senderId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

ConversationProduct _$ConversationProductFromJson(Map<String, dynamic> json) =>
    ConversationProduct(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ConversationProductToJson(
  ConversationProduct instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'image': instance.image,
};

ConversationService _$ConversationServiceFromJson(Map<String, dynamic> json) =>
    ConversationService(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
    );

Map<String, dynamic> _$ConversationServiceToJson(
  ConversationService instance,
) => <String, dynamic>{'id': instance.id, 'title': instance.title};
