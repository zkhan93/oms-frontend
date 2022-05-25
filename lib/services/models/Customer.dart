import 'package:json_annotation/json_annotation.dart';
part 'Customer.g.dart';

@JsonSerializable()
class Customer {
  final int id;
  final String ship;
  final String supervisor;
  final String username;
  final String contact;
  final int? user;

  const Customer({
    required this.id,
    required this.username,
    required this.user,
    required this.contact,
    required this.ship,
    required this.supervisor,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
