// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      json['name'] as String,
      json['unit'] as String,
      (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
    };
