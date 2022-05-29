// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ItemsResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemsResponse _$ItemsResponseFromJson(Map<String, dynamic> json) =>
    ItemsResponse(
      json['count'] as int,
      (json['results'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['next'] as String?,
      json['previous'] as String?,
    );

Map<String, dynamic> _$ItemsResponseToJson(ItemsResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'results': instance.results,
      'next': instance.next,
      'previous': instance.previous,
    };
