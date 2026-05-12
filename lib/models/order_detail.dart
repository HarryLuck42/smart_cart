import 'package:json_annotation/json_annotation.dart';

part 'order_detail.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderDetailItem {
  final int id;
  final String? name;
  final int quantity;
  final double? unitPrice;

  const OrderDetailItem({
    required this.id,
    this.name,
    required this.quantity,
    this.unitPrice,
  });

  factory OrderDetailItem.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailItemToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderDetail {
  final int id;
  final String tableId;
  final String status;
  final int? estimatedPreparationTime;
  final String? customerNote;
  final String? createdAt;
  final List<OrderDetailItem>? items;

  const OrderDetail({
    required this.id,
    required this.tableId,
    required this.status,
    this.estimatedPreparationTime,
    this.customerNote,
    this.createdAt,
    this.items,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class GetOrderResponse {
  final bool success;
  final String? message;
  final OrderDetail? data;

  const GetOrderResponse({required this.success, this.message, this.data});

  factory GetOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$GetOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetOrderResponseToJson(this);
}
