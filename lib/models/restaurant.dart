import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Restaurant {
  final String id;
  final String name;

  const Restaurant({required this.id, required this.name});

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
