// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      json['customer_id'] as int?,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      userId: json['user_id'] as int,
      token: json['token'] as String,
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'user_id': instance.userId,
      'customer_id': instance.customerId,
      'token': instance.token,
      'roles': instance.roles,
    };
