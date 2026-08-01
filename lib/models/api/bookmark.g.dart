// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => Bookmark(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  product: json['product'] == null
      ? null
      : Product.fromJson(json['product'] as Map<String, dynamic>),
  service: json['service'] == null
      ? null
      : Service.fromJson(json['service'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'product': instance.product,
  'service': instance.service,
  'createdAt': instance.createdAt.toIso8601String(),
};
