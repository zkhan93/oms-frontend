import 'package:json_annotation/json_annotation.dart';
part 'OrderItem.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderItem {
  int id;
  String name;
  double quantity;
  String? price;
  String unit;

  OrderItem(
    this.id,
    this.name,
    this.unit,
    this.quantity,
    this.price,
  );

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
