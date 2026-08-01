import 'package:json_annotation/json_annotation.dart';
import 'product.dart';
import 'service.dart';

part 'bookmark.g.dart';

@JsonSerializable()
class Bookmark {
  final int id;
  final String type;
  final Product? product;
  final Service? service;
  final DateTime createdAt;

  Bookmark({
    required this.id,
    required this.type,
    this.product,
    this.service,
    required this.createdAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkToJson(this);
}
