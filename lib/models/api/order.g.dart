// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderProduct _$OrderProductFromJson(Map<String, dynamic> json) => OrderProduct(
  title: json['title'] as String,
  image: json['image'] as String?,
);

Map<String, dynamic> _$OrderProductToJson(OrderProduct instance) =>
    <String, dynamic>{'title': instance.title, 'image': instance.image};

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  id: (json['id'] as num).toInt(),
  orderNumber: json['orderNumber'] as String,
  status: json['status'] as String,
  paymentStatus: json['paymentStatus'] as String,
  deliveryStatus: json['deliveryStatus'] as String,
  itemPrice: (json['itemPrice'] as num).toDouble(),
  serviceFee: (json['serviceFee'] as num).toDouble(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  paymentMethod: json['paymentMethod'] as String,
  deliveryLocation: json['deliveryLocation'] as String?,
  product: json['product'] == null
      ? null
      : OrderProduct.fromJson(json['product'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id': instance.id,
  'orderNumber': instance.orderNumber,
  'status': instance.status,
  'paymentStatus': instance.paymentStatus,
  'deliveryStatus': instance.deliveryStatus,
  'itemPrice': instance.itemPrice,
  'serviceFee': instance.serviceFee,
  'totalAmount': instance.totalAmount,
  'paymentMethod': instance.paymentMethod,
  'deliveryLocation': instance.deliveryLocation,
  'product': instance.product,
  'createdAt': instance.createdAt.toIso8601String(),
};
