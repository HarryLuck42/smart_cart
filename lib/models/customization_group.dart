import 'package:json_annotation/json_annotation.dart';
import 'customization_option.dart';

part 'customization_group.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CustomizationGroup {
  final int id;
  final String name;
  final bool required;
  final int maxSelections;
  final List<CustomizationOption> options;

  const CustomizationGroup({
    required this.id,
    required this.name,
    required this.required,
    required this.maxSelections,
    required this.options,
  });

  factory CustomizationGroup.fromJson(Map<String, dynamic> json) =>
      _$CustomizationGroupFromJson(json);

  Map<String, dynamic> toJson() => _$CustomizationGroupToJson(this);
}
