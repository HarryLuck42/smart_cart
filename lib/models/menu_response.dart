import 'package:json_annotation/json_annotation.dart';
import 'category.dart';
import 'menu_item.dart';
import 'restaurant.dart';

part 'menu_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MenuResponse {
  final Restaurant restaurant;
  final List<Category> categories;
  final List<MenuItem> items;

  const MenuResponse({
    required this.restaurant,
    required this.categories,
    required this.items,
  });

  factory MenuResponse.fromJson(Map<String, dynamic> json) =>
      _$MenuResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MenuResponseToJson(this);

  List<MenuItem> itemsByCategory(int categoryId) =>
      items.where((item) => item.categoryId == categoryId).toList();
}
