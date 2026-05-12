import 'package:json_annotation/json_annotation.dart';
import 'category.dart';

part 'categories_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoriesResponse {
  final bool success;
  final List<Category> data;

  const CategoriesResponse({
    required this.success,
    required this.data,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesResponseToJson(this);
}
