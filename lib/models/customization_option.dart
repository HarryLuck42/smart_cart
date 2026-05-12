import 'package:json_annotation/json_annotation.dart';

part 'customization_option.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CustomizationOption {
  final int id;
  final String name;
  final double priceModifier;

  const CustomizationOption({
    required this.id,
    required this.name,
    required this.priceModifier,
  });

  factory CustomizationOption.fromJson(Map<String, dynamic> json) =>
      _$CustomizationOptionFromJson(json);

  Map<String, dynamic> toJson() => _$CustomizationOptionToJson(this);
}
