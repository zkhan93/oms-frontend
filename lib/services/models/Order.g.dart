// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as int,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      created_on: json['created_on'] as String,
      comment: json['comment'] as String?,
      state: json['state'] as String,
      item_count: json['item_count'] as int,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'customer': instance.customer,
      'created_on': instance.created_on,
      'comment': instance.comment,
      'state': instance.state,
      'item_count': instance.item_count,
    };
