import 'package:cart_app/components/menu_item_card.dart';
import 'package:cart_app/models/customization_group.dart';
import 'package:cart_app/models/menu_item.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_app.dart';
import '../../helpers/fixtures.dart';

void main() {
  group('MenuItemCard', () {
    testWidgets('displays item name', (tester) async {
      await tester.pumpWidget(buildTestApp(MenuItemCard(item: kTestMenuItem)));
      expect(find.text('Nasi Goreng'), findsOneWidget);
    });

    testWidgets('displays formatted price', (tester) async {
      await tester.pumpWidget(buildTestApp(MenuItemCard(item: kTestMenuItem)));
      expect(find.text('\$12.00'), findsOneWidget);
    });

    testWidgets('displays item description', (tester) async {
      await tester.pumpWidget(buildTestApp(MenuItemCard(item: kTestMenuItem)));
      expect(find.text('Fried rice with egg'), findsOneWidget);
    });

    testWidgets('displays Add button', (tester) async {
      await tester.pumpWidget(buildTestApp(MenuItemCard(item: kTestMenuItem)));
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('displays category label when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(MenuItemCard(item: kTestMenuItem, categoryLabel: 'Rice')),
      );
      expect(find.text('Rice'), findsOneWidget);
    });

    testWidgets('does not display category label when omitted', (tester) async {
      await tester.pumpWidget(buildTestApp(MenuItemCard(item: kTestMenuItem)));
      expect(find.text('Rice'), findsNothing);
    });

    testWidgets('displays customization badge for each group', (tester) async {
      const itemWithGroups = MenuItem(
        id: 3,
        name: 'Sate',
        description: 'Grilled skewers',
        price: 8.00,
        categoryId: 10,
        customizationGroups: [
          CustomizationGroup(
            id: 1,
            name: 'Sauce',
            required: false,
            maxSelections: 1,
            options: [],
          ),
        ],
      );
      await tester.pumpWidget(buildTestApp(MenuItemCard(item: itemWithGroups)));
      expect(find.text('Sauce'), findsOneWidget);
    });
  });
}
