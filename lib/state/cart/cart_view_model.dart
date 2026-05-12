import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/cart_item.dart';
import '../../models/customization_option.dart';
import '../../models/menu_item.dart';
import 'cart_state.dart';

class CartViewModel extends StateNotifier<CartState> {
  CartViewModel() : super(const CartState());

  void add(MenuItem item, List<CustomizationOption> options) {
    final newKey = CartItem(item: item, selectedOptions: options).key;
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((i) => i.key == newKey);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(quantity: items[idx].quantity + 1);
    } else {
      items.add(CartItem(item: item, selectedOptions: options));
    }
    state = state.copyWith(items: items);
  }

  void increment(int index) {
    final items = List<CartItem>.from(state.items);
    items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    state = state.copyWith(items: items);
  }

  void decrement(int index) {
    final items = List<CartItem>.from(state.items);
    if (items[index].quantity > 1) {
      items[index] = items[index].copyWith(quantity: items[index].quantity - 1);
    } else {
      items.removeAt(index);
    }
    state = state.copyWith(items: items);
  }

  void remove(int index) {
    final items = List<CartItem>.from(state.items);
    items.removeAt(index);
    state = state.copyWith(items: items);
  }

  void clear() => state = const CartState();
}
