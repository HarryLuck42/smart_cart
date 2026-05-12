import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/order_repository.dart';
import 'order_tracking_state.dart';

class OrderTrackingViewModel extends StateNotifier<OrderTrackingState> {
  final OrderRepository _repository;
  final String _orderId;
  Timer? _timer;

  static const _pollInterval = Duration(seconds: 15);
  static const _terminalStatus = 'served';

  OrderTrackingViewModel(this._repository, this._orderId)
      : super(const OrderTrackingState()) {
    fetchOrder();
    _timer = Timer.periodic(_pollInterval, (_) => fetchOrder());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchOrder() async {
    if (!mounted) return;
    // Show spinner only on the initial fetch; background refreshes are silent.
    if (state.order == null) {
      state = const OrderTrackingState(isLoading: true);
    }
    try {
      final order = await _repository.getOrder(_orderId);
      if (!mounted) return;
      state = OrderTrackingState(order: order, isLoading: false);
      if (order.status == _terminalStatus) {
        _timer?.cancel();
      }
    } catch (e) {
      if (!mounted) return;
      state = OrderTrackingState(
        order: state.order,
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
