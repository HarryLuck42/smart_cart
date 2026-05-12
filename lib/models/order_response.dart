import 'package:json_annotation/json_annotation.dart';

part 'order_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderData {
  final int id;

  const OrderData({required this.id});

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      _$OrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderResponse {
  final bool success;
  final String? message;
  final OrderData? data;

  const OrderResponse({required this.success, this.message, this.data});

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}
