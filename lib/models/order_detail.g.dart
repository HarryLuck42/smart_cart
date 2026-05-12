// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemCustomization _$OrderItemCustomizationFromJson(
  Map<String, dynamic> json,
) => OrderItemCustomization(
  optionId: (json['option_id'] as num).toInt(),
  optionName: json['option_name'] as String,
  priceModifier: (json['price_modifier'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$OrderItemCustomizationToJson(
  OrderItemCustomization instance,
) => <String, dynamic>{
  'option_id': instance.optionId,
  'option_name': instance.optionName,
  'price_modifier': instance.priceModifier,
  'quantity': instance.quantity,
};

OrderDetailItem _$OrderDetailItemFromJson(Map<String, dynamic> json) =>
    OrderDetailItem(
      id: (json['id'] as num).toInt(),
      menuItemId: (json['menu_item_id'] as num).toInt(),
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      customizations:
          (json['customizations'] as List<dynamic>?)
              ?.map(
                (e) =>
                    OrderItemCustomization.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$OrderDetailItemToJson(OrderDetailItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'menu_item_id': instance.menuItemId,
      'name': instance.name,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'subtotal': instance.subtotal,
      'customizations': instance.customizations,
    };

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) => OrderDetail(
  id: (json['id'] as num).toInt(),
  tableId: json['table_id'] as String,
  status: json['status'] as String,
  customerNote: json['customer_note'] as String?,
  totalPrice: (json['total_price'] as num).toDouble(),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderDetailItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'table_id': instance.tableId,
      'status': instance.status,
      'customer_note': instance.customerNote,
      'total_price': instance.totalPrice,
      'items': instance.items,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

GetOrderResponse _$GetOrderResponseFromJson(Map<String, dynamic> json) =>
    GetOrderResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : OrderDetail.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetOrderResponseToJson(GetOrderResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
