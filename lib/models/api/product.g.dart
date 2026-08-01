// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seller _$SellerFromJson(Map<String, dynamic> json) => Seller(
  id: (json['id'] as num).toInt(),
  fullName: json['fullName'] as String,
  username: json['username'] as String,
  rating: (json['rating'] as num?)?.toDouble(),
);

Map<String, dynamic> _$SellerToJson(Seller instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'username': instance.username,
  'rating': instance.rating,
};

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  originalPrice: (json['originalPrice'] as num?)?.toDouble(),
  conditionType: json['conditionType'] as String,
  negotiable: json['negotiable'] as bool,
  availability: json['availability'] as String,
  stockQuantity: (json['stockQuantity'] as num).toInt(),
  deliveryFee: (json['deliveryFee'] as num).toDouble(),
  category: json['category'] == null
      ? null
      : Category.fromJson(json['category'] as Map<String, dynamic>),
  seller: json['seller'] == null
      ? null
      : Seller.fromJson(json['seller'] as Map<String, dynamic>),
  primaryImage: json['primaryImage'] as String?,
  viewsCount: (json['viewsCount'] as num).toInt(),
  bookmarksCount: (json['bookmarksCount'] as num).toInt(),
  isBookmarked: json['isBookmarked'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'slug': instance.slug,
  'description': instance.description,
  'price': instance.price,
  'originalPrice': instance.originalPrice,
  'conditionType': instance.conditionType,
  'negotiable': instance.negotiable,
  'availability': instance.availability,
  'stockQuantity': instance.stockQuantity,
  'deliveryFee': instance.deliveryFee,
  'category': instance.category,
  'seller': instance.seller,
  'primaryImage': instance.primaryImage,
  'viewsCount': instance.viewsCount,
  'bookmarksCount': instance.bookmarksCount,
  'isBookmarked': instance.isBookmarked,
  'createdAt': instance.createdAt.toIso8601String(),
};
