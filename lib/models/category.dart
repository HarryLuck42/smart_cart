import 'package:json_annotation/json_annotation.dart';
import 'menu_item.dart';

part 'category.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Category {
  final int id;
  final String name;
  final int sortOrder;
  final List<MenuItem> items;

  const Category({
    required this.id,
    required this.name,
    required this.sortOrder,
    this.items = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final cat = _$CategoryFromJson(json);
    return Category(
      id: cat.id,
      name: cat.name,
      sortOrder: cat.sortOrder,
      items: cat.items.map((item) => item.copyWith(categoryId: cat.id)).toList(),
    );
  }

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
