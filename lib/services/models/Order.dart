import 'package:json_annotation/json_annotation.dart';
import 'package:order/services/models/Customer.dart';
part 'Order.g.dart';

@JsonSerializable()
class Order {
  final int id;
  final Customer customer;
  final String created_on;
  final String? comment;
  final String state;
  final int item_count;

  const Order(
      {required this.id,
      required this.customer,
      required this.created_on,
      required this.comment,
      required this.state,
      required this.item_count});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
