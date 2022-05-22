import 'package:json_annotation/json_annotation.dart';
import 'package:order/services/models/Item.dart';
part 'ItemsResponse.g.dart';

@JsonSerializable()
class ItemsResponse {
  final int count;
  final List<Item> results;
  String? next;
  String? previous;

  ItemsResponse(this.count, this.results, this.next, this.previous);
  factory ItemsResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ItemsResponseToJson(this);
}
