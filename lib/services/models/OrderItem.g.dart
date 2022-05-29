// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      json['id'] as int,
      json['name'] as String,
      json['unit'] as String,
      (json['quantity'] as num).toDouble(),
      json['price'] as String?,
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'price': instance.price,
      'unit': instance.unit,
    };
