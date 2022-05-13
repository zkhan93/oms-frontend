// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      json['count'] as int,
      (json['results'] as List<dynamic>)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['next'] as String?,
      json['previous'] as String?,
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'results': instance.results,
      'next': instance.next,
      'previous': instance.previous,
    };
