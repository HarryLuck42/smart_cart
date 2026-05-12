import 'package:cart_app/state/cart/cart_state.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/fixtures.dart';

void main() {
  group('CartState', () {
    test('totalCount is 0 for empty cart', () {
      expect(const CartState().totalCount, 0);
    });

    test('totalCount sums item quantities', () {
      final state = CartState(items: [
        makeCartItem(item: kTestMenuItem, quantity: 2),
        makeCartItem(item: kTestMenuItemB, quantity: 3),
      ]);
      expect(state.totalCount, 5);
    });

    test('subtotal is 0.0 for empty cart', () {
      expect(const CartState().subtotal, 0.0);
    });

    test('subtotal sums totalPrice of each item', () {
      final state = CartState(items: [
        makeCartItem(item: kTestMenuItem, quantity: 1), // 12.00
        makeCartItem(item: kTestMenuItemB, quantity: 2), // 20.00
      ]);
      expect(state.subtotal, closeTo(32.00, 0.001));
    });

    test('copyWith replaces items list', () {
      final original = CartState(items: [makeCartItem()]);
      final copy = original.copyWith(items: []);
      expect(copy.items, isEmpty);
    });

    test('copyWith keeps existing items when not provided', () {
      final original = CartState(items: [makeCartItem()]);
      final copy = original.copyWith();
      expect(copy.items.length, 1);
    });
  });
}
