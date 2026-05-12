import 'package:cart_app/state/cart/cart_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/fixtures.dart';

void main() {
  late CartViewModel vm;

  setUp(() => vm = CartViewModel());

  group('CartViewModel', () {
    group('add', () {
      test('adds a new item to an empty cart', () {
        vm.add(kTestMenuItem, []);
        expect(vm.state.items.length, 1);
        expect(vm.state.items.first.item, kTestMenuItem);
        expect(vm.state.items.first.quantity, 1);
      });

      test('increments quantity when item with same key is added again', () {
        vm.add(kTestMenuItem, []);
        vm.add(kTestMenuItem, []);
        expect(vm.state.items.length, 1);
        expect(vm.state.items.first.quantity, 2);
      });

      test('adds as a separate entry when options differ', () {
        vm.add(kTestMenuItem, []);
        vm.add(kTestMenuItem, [kTestOption]);
        expect(vm.state.items.length, 2);
      });

      test('adds different items as separate entries', () {
        vm.add(kTestMenuItem, []);
        vm.add(kTestMenuItemB, []);
        expect(vm.state.items.length, 2);
      });
    });

    group('increment', () {
      test('increases item quantity by 1', () {
        vm.add(kTestMenuItem, []);
        vm.increment(0);
        expect(vm.state.items[0].quantity, 2);
      });
    });

    group('decrement', () {
      test('decreases quantity by 1 when quantity > 1', () {
        vm.add(kTestMenuItem, []);
        vm.increment(0); // quantity = 2
        vm.decrement(0); // quantity = 1
        expect(vm.state.items[0].quantity, 1);
      });

      test('removes item when quantity reaches 0', () {
        vm.add(kTestMenuItem, []);
        vm.decrement(0);
        expect(vm.state.items, isEmpty);
      });
    });

    group('remove', () {
      test('removes the item at the given index', () {
        vm.add(kTestMenuItem, []);
        vm.add(kTestMenuItemB, []);
        vm.remove(0);
        expect(vm.state.items.length, 1);
        expect(vm.state.items.first.item, kTestMenuItemB);
      });
    });

    group('clear', () {
      test('removes all items from the cart', () {
        vm.add(kTestMenuItem, []);
        vm.add(kTestMenuItemB, []);
        vm.clear();
        expect(vm.state.items, isEmpty);
      });

      test('totalCount is 0 after clear', () {
        vm.add(kTestMenuItem, []);
        vm.clear();
        expect(vm.state.totalCount, 0);
      });
    });
  });
}
