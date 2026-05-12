import 'package:flutter/foundation.dart';
import '../../models/cart_item.dart';

@immutable
class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get totalCount => items.fold(0, (s, i) => s + i.quantity);
  double get subtotal => items.fold(0.0, (s, i) => s + i.totalPrice);

  CartState copyWith({List<CartItem>? items}) =>
      CartState(items: items ?? this.items);
}
