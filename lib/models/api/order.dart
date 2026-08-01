import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class OrderProduct {
  final String title;
  final String? image;

  OrderProduct({
    required this.title,
    this.image,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductToJson(this);
}

@JsonSerializable()
class Order {
  final int id;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final String deliveryStatus;
  final double itemPrice;
  final double serviceFee;
  final double totalAmount;
  final String paymentMethod;
  final String? deliveryLocation;
  final OrderProduct? product;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.deliveryStatus,
    required this.itemPrice,
    required this.serviceFee,
    required this.totalAmount,
    required this.paymentMethod,
    this.deliveryLocation,
    this.product,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
