import 'package:json_annotation/json_annotation.dart';
part 'Token.g.dart';

@JsonSerializable()
class Token {
  @JsonKey(name: "user_id")
  final int userId;
  final String token;
  final String email;
  final List<String> roles;

  const Token(
    this.roles, {
    required this.email,
    required this.userId,
    required this.token,
  });

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
