// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailItem _$OrderDetailItemFromJson(Map<String, dynamic> json) =>
    OrderDetailItem(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderDetailItemToJson(OrderDetailItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
    };

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) => OrderDetail(
  id: (json['id'] as num).toInt(),
  tableId: json['table_id'] as String,
  status: json['status'] as String,
  estimatedPreparationTime: (json['estimated_preparation_time'] as num?)
      ?.toInt(),
  customerNote: json['customer_note'] as String?,
  createdAt: json['created_at'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => OrderDetailItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'table_id': instance.tableId,
      'status': instance.status,
      'estimated_preparation_time': instance.estimatedPreparationTime,
      'customer_note': instance.customerNote,
      'created_at': instance.createdAt,
      'items': instance.items,
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
