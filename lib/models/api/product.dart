import 'package:json_annotation/json_annotation.dart';
import 'category.dart';

part 'product.g.dart';

@JsonSerializable()
class Seller {
  final int id;
  final String fullName;
  final String username;
  final double? rating;

  Seller({
    required this.id,
    required this.fullName,
    required this.username,
    this.rating,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => _$SellerFromJson(json);

  Map<String, dynamic> toJson() => _$SellerToJson(this);
}

@JsonSerializable()
class Product {
  final int id;
  final String title;
  final String slug;
  final String description;
  final double price;
  final double? originalPrice;
  final String conditionType;
  final bool negotiable;
  final String availability;
  final int stockQuantity;
  final double deliveryFee;
  final Category? category;
  final Seller? seller;
  final String? primaryImage;
  final int viewsCount;
  final int bookmarksCount;
  final bool isBookmarked;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.conditionType,
    required this.negotiable,
    required this.availability,
    required this.stockQuantity,
    required this.deliveryFee,
    this.category,
    this.seller,
    this.primaryImage,
    required this.viewsCount,
    required this.bookmarksCount,
    required this.isBookmarked,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  double get discountPercentage {
    if (originalPrice == null || originalPrice == 0) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }
}
