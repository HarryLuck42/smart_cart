import 'package:cart_app/models/cart_item.dart';
import 'package:cart_app/models/customization_option.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/fixtures.dart';

void main() {
  group('CartItem', () {
    test('unitPrice equals item.price when no options selected', () {
      final cartItem = CartItem(item: kTestMenuItem, selectedOptions: []);
      expect(cartItem.unitPrice, 12.00);
    });

    test('unitPrice adds all option priceModifiers', () {
      const optB = CustomizationOption(id: 2, name: 'No MSG', priceModifier: 0.50);
      final cartItem = CartItem(
        item: kTestMenuItem,
        selectedOptions: [kTestOption, optB],
      );
      expect(cartItem.unitPrice, closeTo(14.00, 0.001));
    });

    test('totalPrice is unitPrice × quantity', () {
      final cartItem = CartItem(
        item: kTestMenuItem,
        selectedOptions: [],
        quantity: 3,
      );
      expect(cartItem.totalPrice, closeTo(36.00, 0.001));
    });

    test('key includes item id and sorted option ids', () {
      const optA = CustomizationOption(id: 3, name: 'A', priceModifier: 0);
      const optB = CustomizationOption(id: 1, name: 'B', priceModifier: 0);
      final cartItem = CartItem(
        item: kTestMenuItem,
        selectedOptions: [optA, optB],
      );
      expect(cartItem.key, '1_1,3');
    });

    test('key with no options is itemId_', () {
      final cartItem = CartItem(item: kTestMenuItem, selectedOptions: []);
      expect(cartItem.key, '1_');
    });

    test('two items with same item and options share the same key', () {
      final a = CartItem(item: kTestMenuItem, selectedOptions: [kTestOption]);
      final b = CartItem(item: kTestMenuItem, selectedOptions: [kTestOption]);
      expect(a.key, b.key);
    });

    test('copyWith changes only quantity', () {
      final original = CartItem(
        item: kTestMenuItem,
        selectedOptions: [kTestOption],
        quantity: 2,
      );
      final copy = original.copyWith(quantity: 5);
      expect(copy.quantity, 5);
      expect(copy.item, original.item);
      expect(copy.selectedOptions, original.selectedOptions);
    });
  });
}
