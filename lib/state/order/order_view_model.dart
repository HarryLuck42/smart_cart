import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/order_repository.dart';
import '../../models/cart_item.dart';
import 'order_state.dart';

class OrderViewModel extends StateNotifier<OrderState> {
  final OrderRepository _repository;

  OrderViewModel(this._repository) : super(const OrderState());

  Future<void> submitOrder({
    required String tableId,
    required List<CartItem> items,
    required String customerNote,
  }) async {
    if (state.isSubmitting) return;
    state = const OrderState(isSubmitting: true);
    try {
      final orderId = await _repository.submitOrder(
        tableId: tableId,
        items: items,
        customerNote: customerNote,
      );
      state = OrderState(orderId: orderId);
    } catch (e) {
      state = OrderState(errorMessage: e.toString());
    }
  }

  void reset() => state = const OrderState();
}
