import 'package:json_annotation/json_annotation.dart';

part 'order_detail.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderItemCustomization {
  final int optionId;
  final String optionName;
  final double priceModifier;
  final int quantity;

  const OrderItemCustomization({
    required this.optionId,
    required this.optionName,
    required this.priceModifier,
    required this.quantity,
  });

  factory OrderItemCustomization.fromJson(Map<String, dynamic> json) =>
      _$OrderItemCustomizationFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemCustomizationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderDetailItem {
  final int id;
  final int menuItemId;
  final String name;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final List<OrderItemCustomization> customizations;

  const OrderDetailItem({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.customizations = const [],
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
  final String? customerNote;
  final double totalPrice;
  final List<OrderDetailItem> items;
  final String? createdAt;
  final String? updatedAt;

  const OrderDetail({
    required this.id,
    required this.tableId,
    required this.status,
    this.customerNote,
    required this.totalPrice,
    this.items = const [],
    this.createdAt,
    this.updatedAt,
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
