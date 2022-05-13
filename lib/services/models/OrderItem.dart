import 'package:json_annotation/json_annotation.dart';
part 'OrderItem.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderItem {
  String name;
  double quantity;
  String unit;

  OrderItem(
    this.name,
    this.unit,
    this.quantity,
  );

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
