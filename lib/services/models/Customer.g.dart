// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as int,
      username: json['username'] as String,
      user: json['user'] as int?,
      contact: json['contact'] as String,
      ship: json['ship'] as String,
      supervisor: json['supervisor'] as String,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'ship': instance.ship,
      'supervisor': instance.supervisor,
      'username': instance.username,
      'contact': instance.contact,
      'user': instance.user,
    };
