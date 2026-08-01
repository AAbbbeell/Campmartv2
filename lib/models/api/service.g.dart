// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceProvider _$ServiceProviderFromJson(Map<String, dynamic> json) =>
    ServiceProvider(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String,
      username: json['username'] as String,
      rating: (json['rating'] as num?)?.toDouble(),
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$ServiceProviderToJson(ServiceProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'username': instance.username,
      'rating': instance.rating,
      'profileImage': instance.profileImage,
    };

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String,
  shortDescription: json['shortDescription'] as String?,
  pricingType: json['pricingType'] as String,
  price: (json['price'] as num).toDouble(),
  deliveryTime: json['deliveryTime'] as String?,
  availability: json['availability'] as String,
  rating: (json['rating'] as num).toDouble(),
  totalRatings: (json['totalRatings'] as num).toInt(),
  totalOrders: (json['totalOrders'] as num).toInt(),
  viewsCount: (json['viewsCount'] as num).toInt(),
  bookmarksCount: (json['bookmarksCount'] as num).toInt(),
  portfolioImages: (json['portfolioImages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  skills: (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
  isFeatured: json['isFeatured'] as bool,
  isBookmarked: json['isBookmarked'] as bool,
  category: json['category'] == null
      ? null
      : Category.fromJson(json['category'] as Map<String, dynamic>),
  provider: json['provider'] == null
      ? null
      : ServiceProvider.fromJson(json['provider'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'slug': instance.slug,
  'description': instance.description,
  'shortDescription': instance.shortDescription,
  'pricingType': instance.pricingType,
  'price': instance.price,
  'deliveryTime': instance.deliveryTime,
  'availability': instance.availability,
  'rating': instance.rating,
  'totalRatings': instance.totalRatings,
  'totalOrders': instance.totalOrders,
  'viewsCount': instance.viewsCount,
  'bookmarksCount': instance.bookmarksCount,
  'portfolioImages': instance.portfolioImages,
  'skills': instance.skills,
  'isFeatured': instance.isFeatured,
  'isBookmarked': instance.isBookmarked,
  'category': instance.category,
  'provider': instance.provider,
  'createdAt': instance.createdAt.toIso8601String(),
};
