// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      email: json['email'] as String,
      userId: json['user_id'] as int,
      token: json['token'] as String,
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'user_id': instance.userId,
      'token': instance.token,
      'email': instance.email,
      'roles': instance.roles,
    };
