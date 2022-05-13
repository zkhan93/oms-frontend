// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) => OrderDetail(
      id: json['id'] as int,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      created_on: json['created_on'] as String,
      comment: json['comment'] as String?,
      state: json['state'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer': instance.customer.toJson(),
      'created_on': instance.created_on,
      'comment': instance.comment,
      'state': instance.state,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
