import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/dio_client.dart';
import '../api/menu_api_service.dart';
import '../api/menu_repository.dart';
import '../api/order_api_service.dart';
import '../api/order_repository.dart';
import '../services/order_cache.dart';
import 'scanner/scanner_state.dart';
import 'scanner/scanner_view_model.dart';
import 'menu/menu_state.dart';
import 'menu/menu_view_model.dart';
import 'cart/cart_state.dart';
import 'cart/cart_view_model.dart';
import 'order/order_state.dart';
import 'order/order_view_model.dart';
import 'order_tracking/order_tracking_state.dart';
import 'order_tracking/order_tracking_view_model.dart';

// ── Order cache ───────────────────────────────────────────────────────────────

final orderCacheProvider =
    StateNotifierProvider<OrderCacheNotifier, String?>(
  (_) => OrderCacheNotifier(),
);

// ── Network ───────────────────────────────────────────────────────────────────

final dioProvider = Provider<Dio>(
  (_) => DioClient.create(),
);

final menuApiServiceProvider = Provider<MenuApiService>(
  (ref) => MenuApiService(ref.read(dioProvider)),
);

// ── Repository ────────────────────────────────────────────────────────────────

final menuRepositoryProvider = Provider<MenuRepository>(
  (ref) => MenuRepository(ref.read(menuApiServiceProvider)),
);

// ── Scanner ───────────────────────────────────────────────────────────────────

final scannerViewModelProvider =
    StateNotifierProvider.autoDispose<ScannerViewModel, ScannerState>(
  (_) => ScannerViewModel(),
);

// ── Menu ──────────────────────────────────────────────────────────────────────

/// Auto-disposed when the menu screen leaves the tree.
final menuViewModelProvider = StateNotifierProvider.autoDispose
    .family<MenuViewModel, MenuState, String>(
  (ref, tableId) => MenuViewModel(ref.read(menuRepositoryProvider), tableId),
);

// ── Cart ──────────────────────────────────────────────────────────────────────

/// Lives for the lifetime of the app.
final cartViewModelProvider =
    StateNotifierProvider<CartViewModel, CartState>(
  (_) => CartViewModel(),
);

// ── Computed cart values ──────────────────────────────────────────────────────

final cartTotalCountProvider = Provider<int>(
  (ref) => ref.watch(cartViewModelProvider).totalCount,
);

final cartSubtotalProvider = Provider<double>(
  (ref) => ref.watch(cartViewModelProvider).subtotal,
);

// ── Order ─────────────────────────────────────────────────────────────────────

final orderApiServiceProvider = Provider<OrderApiService>(
  (ref) => OrderApiService(ref.read(dioProvider)),
);

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => OrderRepository(ref.read(orderApiServiceProvider)),
);

/// Lives for the lifetime of the app; reset after each successful submission.
final orderViewModelProvider =
    StateNotifierProvider<OrderViewModel, OrderState>(
  (ref) => OrderViewModel(ref.read(orderRepositoryProvider)),
);

// ── Order tracking ────────────────────────────────────────────────────────────

/// Auto-disposed when the tracking screen leaves the tree.
final orderTrackingViewModelProvider = StateNotifierProvider.autoDispose
    .family<OrderTrackingViewModel, OrderTrackingState, String>(
  (ref, orderId) =>
      OrderTrackingViewModel(ref.read(orderRepositoryProvider), orderId),
);
