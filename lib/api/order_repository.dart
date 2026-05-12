import '../models/cart_item.dart';
import '../models/order_detail.dart';
import '../models/order_request.dart';
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

    final response = await _apiService.submitOrder(request.toJson());

    if (!response.success || response.data == null) {
      throw Exception(response.message ?? 'Order submission failed');
    }

    return '${response.data!.id}';
  }

  Future<OrderDetail> getOrder(String orderId) async {
    final response = await _apiService.getOrder(orderId);
    if (!response.success || response.data == null) {
      throw Exception(response.message ?? 'Failed to fetch order');
    }
    return response.data!;
  }
}
