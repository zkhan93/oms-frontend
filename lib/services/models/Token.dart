import 'package:json_annotation/json_annotation.dart';
part 'Token.g.dart';

@JsonSerializable()
class Token {
  final int user_id;
  final String token;
  final String email;

  const Token({
    required this.email,
    required this.user_id,
    required this.token,
  });

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
