import 'package:json_annotation/json_annotation.dart';
import 'package:order/services/models/Customer.dart';
import 'package:order/services/models/OrderItem.dart';
part 'OrderDetail.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderDetail {
  final int id;
  final Customer customer;
  final String created_on;
  final String? comment;
  final String state;
  final List<OrderItem> items;

  const OrderDetail(
      {required this.id,
      required this.customer,
      required this.created_on,
      required this.comment,
      required this.state,
      required this.items});

  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}
