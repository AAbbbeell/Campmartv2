import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable()
class CartItem {
  final int id;
  final int productId;
  final int quantity;
  final String deliveryOption;
  final String title;
  final double price;
  final double itemTotal;
  final double deliveryFee;
  final String? productImage;

  CartItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.deliveryOption,
    required this.title,
    required this.price,
    required this.itemTotal,
    required this.deliveryFee,
    this.productImage,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}

@JsonSerializable()
class CartSummary {
  final List<CartItem> items;
  final int totalItems;
  final double subtotal;
  final double totalDeliveryFee;
  final double totalAmount;

  CartSummary({
    required this.items,
    required this.totalItems,
    required this.subtotal,
    required this.totalDeliveryFee,
    required this.totalAmount,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$CartSummaryToJson(this);
}
