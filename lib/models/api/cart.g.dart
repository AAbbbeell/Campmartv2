// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
  id: (json['id'] as num).toInt(),
  productId: (json['productId'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
  deliveryOption: json['deliveryOption'] as String,
  title: json['title'] as String,
  price: (json['price'] as num).toDouble(),
  itemTotal: (json['itemTotal'] as num).toDouble(),
  deliveryFee: (json['deliveryFee'] as num).toDouble(),
  productImage: json['productImage'] as String?,
);

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'productId': instance.productId,
  'quantity': instance.quantity,
  'deliveryOption': instance.deliveryOption,
  'title': instance.title,
  'price': instance.price,
  'itemTotal': instance.itemTotal,
  'deliveryFee': instance.deliveryFee,
  'productImage': instance.productImage,
};

CartSummary _$CartSummaryFromJson(Map<String, dynamic> json) => CartSummary(
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalItems: (json['totalItems'] as num).toInt(),
  subtotal: (json['subtotal'] as num).toDouble(),
  totalDeliveryFee: (json['totalDeliveryFee'] as num).toDouble(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
);

Map<String, dynamic> _$CartSummaryToJson(CartSummary instance) =>
    <String, dynamic>{
      'items': instance.items,
      'totalItems': instance.totalItems,
      'subtotal': instance.subtotal,
      'totalDeliveryFee': instance.totalDeliveryFee,
      'totalAmount': instance.totalAmount,
    };
133