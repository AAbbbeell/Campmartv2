import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  final int id;
  final String title;
  final String message;
  final String type;
  final int? relatedId;
  final String? relatedType;
  final String? actionUrl;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.relatedId,
    this.relatedType,
    this.actionUrl,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
