import 'package:json_annotation/json_annotation.dart';
import 'customization_group.dart';

part 'menu_item.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final int categoryId;
  final String? imageUrl;
  final List<CustomizationGroup> customizationGroups;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.categoryId = 0,
    this.imageUrl,
    required this.customizationGroups,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);

  MenuItem copyWith({int? categoryId}) => MenuItem(
        id: id,
        name: name,
        description: description,
        price: price,
        categoryId: categoryId ?? this.categoryId,
        imageUrl: imageUrl,
        customizationGroups: customizationGroups,
      );
}
