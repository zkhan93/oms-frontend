import 'package:json_annotation/json_annotation.dart';
import 'package:order/services/models/Customer.dart';
import 'package:order/services/models/OrderItem.dart';
part 'OrderDetail.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderDetail {
  final int id;
  final Customer customer;
  @JsonKey(name: "created_on")
  final String createdOn;
  final String? comment;
  final String state;
  final List<OrderItem> items;
  final String? total;

  const OrderDetail({
    required this.id,
    required this.customer,
    required this.createdOn,
    required this.comment,
    required this.state,
    required this.items,
    required this.total,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}
