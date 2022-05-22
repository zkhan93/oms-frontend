import 'package:json_annotation/json_annotation.dart';
part 'Item.g.dart';

@JsonSerializable(explicitToJson: true)
class Item {
  int id;
  String name;
  String? default_price;

  Item({required this.id, required this.name, required this.default_price});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
