import 'package:flutter/foundation.dart';
import '../../models/order_detail.dart';

@immutable
class OrderTrackingState {
  final bool isLoading;
  final OrderDetail? order;
  final String? error;

  const OrderTrackingState({
    this.isLoading = true,
    this.order,
    this.error,
  });
}
