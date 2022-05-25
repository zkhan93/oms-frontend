import 'package:json_annotation/json_annotation.dart';
part 'Token.g.dart';

@JsonSerializable()
class Token {
  @JsonKey(name: "user_id")
  final int userId;
  @JsonKey(name: "customer_id")
  final int? customerId;
  final String token;
  final List<String> roles;

  const Token(
    this.customerId, {
    required this.roles,
    required this.userId,
    required this.token,
  });

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
