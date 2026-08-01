// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String?,
  icon: json['icon'] as String?,
  productCount: (json['productCount'] as num).toInt(),
  colorCode: json['colorCode'] as String?,
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'description': instance.description,
  'icon': instance.icon,
  'productCount': instance.productCount,
  'colorCode': instance.colorCode,
};
