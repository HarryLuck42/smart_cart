import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLastOrderId = 'last_order_id';

class OrderCacheNotifier extends StateNotifier<String?> {
  OrderCacheNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_kLastOrderId);
  }

  Future<void> save(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastOrderId, orderId);
    state = orderId;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLastOrderId);
    state = null;
  }
}
