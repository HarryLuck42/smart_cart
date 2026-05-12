import 'package:dio/dio.dart';
import '../models/cart_item.dart';
import '../models/order_detail.dart';
import '../models/order_request.dart';
import 'api_exception.dart';
import 'order_api_service.dart';

class OrderRepository {
  final OrderApiService _apiService;

  const OrderRepository(this._apiService);

  Future<String> submitOrder({
    required String tableId,
    required List<CartItem> items,
    required String customerNote,
  }) async {
    final request = OrderRequest(
      tableId: tableId,
      customerNote: customerNote,
      items: items
          .map(
            (ci) => OrderItemRequest(
              menuItemId: ci.item.id,
              quantity: ci.quantity,
              customizations: ci.selectedOptions
                  .map((o) => OrderCustomizationRequest(optionId: o.id, quantity: 1))
                  .toList(),
            ),
          )
          .toList(),
    );

    try {
      final response = await _apiService.submitOrder(request.toJson());
      if (!response.success || response.data == null) {
        throw const ApiException(
            code: 'API_ERROR', message: 'Order submission failed.');
      }
      return '${response.data!.id}';
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw _unwrap(e);
    }
  }

  Future<OrderDetail> getOrder(String orderId) async {
    try {
      final response = await _apiService.getOrder(orderId);
      if (!response.success || response.data == null) {
        throw const ApiException(
            code: 'API_ERROR', message: 'Failed to fetch order.');
      }
      return response.data!;
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw _unwrap(e);
    }
  }
}

ApiException _unwrap(DioException e) =>
    e.error is ApiException ? e.error as ApiException : ApiException.fromDio(e);
