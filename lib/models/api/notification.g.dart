// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  message: json['message'] as String,
  type: json['type'] as String,
  relatedId: (json['relatedId'] as num?)?.toInt(),
  relatedType: json['relatedType'] as String?,
  actionUrl: json['actionUrl'] as String?,
  isRead: json['isRead'] as bool,
  readAt: json['readAt'] == null
      ? null
      : DateTime.parse(json['readAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'relatedId': instance.relatedId,
      'relatedType': instance.relatedType,
      'actionUrl': instance.actionUrl,
      'isRead': instance.isRead,
      'readAt': instance.readAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
