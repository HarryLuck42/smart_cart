// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderData _$OrderDataFromJson(Map<String, dynamic> json) => OrderData(
  orderId: (json['order_id'] as num).toInt(),
  tableId: json['table_id'] as String,
  status: json['status'] as String,
  totalPrice: (json['total_price'] as num).toDouble(),
  customerNote: json['customer_note'] as String?,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$OrderDataToJson(OrderData instance) => <String, dynamic>{
  'order_id': instance.orderId,
  'table_id': instance.tableId,
  'status': instance.status,
  'total_price': instance.totalPrice,
  'customer_note': instance.customerNote,
  'created_at': instance.createdAt,
};

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : OrderData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
