// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      email: json['email'] as String,
      user_id: json['user_id'] as int,
      token: json['token'] as String,
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'user_id': instance.user_id,
      'token': instance.token,
      'email': instance.email,
    };
