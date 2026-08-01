import 'package:json_annotation/json_annotation.dart';
import 'category.dart';

part 'service.g.dart';

@JsonSerializable()
class ServiceProvider {
  final int id;
  final String fullName;
  final String username;
  final double? rating;
  final String? profileImage;

  ServiceProvider({
    required this.id,
    required this.fullName,
    required this.username,
    this.rating,
    this.profileImage,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderToJson(this);
}

@JsonSerializable()
class Service {
  final int id;
  final String title;
  final String slug;
  final String description;
  final String? shortDescription;
  final String pricingType;
  final double price;
  final String? deliveryTime;
  final String availability;
  final double rating;
  final int totalRatings;
  final int totalOrders;
  final int viewsCount;
  final int bookmarksCount;
  final List<String>? portfolioImages;
  final List<String>? skills;
  final bool isFeatured;
  final bool isBookmarked;
  final Category? category;
  final ServiceProvider? provider;
  final DateTime createdAt;

  Service({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    this.shortDescription,
    required this.pricingType,
    required this.price,
    this.deliveryTime,
    required this.availability,
    required this.rating,
    required this.totalRatings,
    required this.totalOrders,
    required this.viewsCount,
    required this.bookmarksCount,
    this.portfolioImages,
    this.skills,
    required this.isFeatured,
    required this.isBookmarked,
    this.category,
    this.provider,
    required this.createdAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}
