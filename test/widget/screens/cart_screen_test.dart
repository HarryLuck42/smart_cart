import 'package:cart_app/screens/cart_screen.dart';
import 'package:cart_app/state/cart/cart_view_model.dart';
import 'package:cart_app/state/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_app.dart';
import '../../helpers/fixtures.dart';

void main() {
  group('CartScreen', () {
    testWidgets('shows empty state when cart is empty', (tester) async {
      await tester.pumpWidget(buildTestApp(const CartScreen(tableId: 'T001')));
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('does not show Place Order when cart is empty', (tester) async {
      await tester.pumpWidget(buildTestApp(const CartScreen(tableId: 'T001')));
      expect(find.text('Place Order'), findsNothing);
    });

    testWidgets('shows item name when cart has items', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CartScreen(tableId: 'T001'),
          overrides: [
            cartViewModelProvider.overrideWith((_) {
              final vm = CartViewModel();
              vm.add(kTestMenuItem, []);
              return vm;
            }),
          ],
        ),
      );
      expect(find.text('Nasi Goreng'), findsOneWidget);
    });

    testWidgets('shows Place Order button when cart has items', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CartScreen(tableId: 'T001'),
          overrides: [
            cartViewModelProvider.overrideWith((_) {
              final vm = CartViewModel();
              vm.add(kTestMenuItem, []);
              return vm;
            }),
          ],
        ),
      );
      expect(find.text('Place Order'), findsOneWidget);
    });

    testWidgets('shows note field when cart has items', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CartScreen(tableId: 'T001'),
          overrides: [
            cartViewModelProvider.overrideWith((_) {
              final vm = CartViewModel();
              vm.add(kTestMenuItem, []);
              return vm;
            }),
          ],
        ),
      );
      expect(find.text('Note to kitchen (optional)'), findsOneWidget);
    });

    testWidgets('shows Clear all button when cart has items', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CartScreen(tableId: 'T001'),
          overrides: [
            cartViewModelProvider.overrideWith((_) {
              final vm = CartViewModel();
              vm.add(kTestMenuItem, []);
              return vm;
            }),
          ],
        ),
      );
      expect(find.text('Clear all'), findsOneWidget);
    });

    testWidgets('shows subtotal amount when cart has items', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CartScreen(tableId: 'T001'),
          overrides: [
            cartViewModelProvider.overrideWith((_) {
              final vm = CartViewModel();
              vm.add(kTestMenuItem, []);
              return vm;
            }),
          ],
        ),
      );
      expect(find.text('\$12.00'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows confirm dialog when Clear all is tapped', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CartScreen(tableId: 'T001'),
          overrides: [
            cartViewModelProvider.overrideWith((_) {
              final vm = CartViewModel();
              vm.add(kTestMenuItem, []);
              return vm;
            }),
          ],
        ),
      );
      await tester.tap(find.text('Clear all'));
      await tester.pumpAndSettle();
      expect(find.text('Clear cart?'), findsOneWidget);
    });
  });
}
