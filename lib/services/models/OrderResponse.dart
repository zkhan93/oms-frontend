import 'package:json_annotation/json_annotation.dart';
import 'package:order/services/models/Order.dart';
part 'OrderResponse.g.dart';

@JsonSerializable()
class OrderResponse {
  final int count;
  final List<Order> results;
  String? next;
  String? previous;

  OrderResponse(this.count, this.results, this.next, this.previous);
  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}
