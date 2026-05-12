import 'package:flutter/foundation.dart';

@immutable
class OrderState {
  final bool isSubmitting;
  final String? orderId;
  final String? errorMessage;

  const OrderState({
    this.isSubmitting = false,
    this.orderId,
    this.errorMessage,
  });

  bool get isIdle => !isSubmitting && orderId == null && errorMessage == null;
  bool get isSuccess => orderId != null;
  bool get isError => errorMessage != null;
}
