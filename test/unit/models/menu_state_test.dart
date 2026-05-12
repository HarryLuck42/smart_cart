import 'package:cart_app/state/menu/menu_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/fixtures.dart';

void main() {
  group('MenuState', () {
    MenuState filled() => MenuState(
          data: AsyncData(makeMenuResponse(
            items: [kTestMenuItem, kTestMenuItemB],
            categories: [kTestCategoryA, kTestCategoryB],
          )),
          categories: const AsyncData([kTestCategoryA, kTestCategoryB]),
        );

    group('sortedCategories', () {
      test('sorts by sortOrder ascending', () {
        final sorted = filled().sortedCategories;
        expect(sorted.first.name, 'Appetizers'); // sortOrder: 1
        expect(sorted.last.name, 'Rice'); // sortOrder: 2
      });

      test('returns empty list when categories are loading', () {
        expect(const MenuState().sortedCategories, isEmpty);
      });
    });

    group('allItems', () {
      test('returns every item from menu data', () {
        expect(filled().allItems.length, 2);
      });

      test('returns empty list when data is loading', () {
        expect(const MenuState().allItems, isEmpty);
      });
    });

    group('itemsForCategory', () {
      test('filters items by categoryId', () {
        final items = filled().itemsForCategory(10);
        expect(items.length, 2);
        expect(items.every((i) => i.categoryId == 10), isTrue);
      });

      test('returns empty for unknown categoryId', () {
        expect(filled().itemsForCategory(99), isEmpty);
      });
    });

    group('searchResults', () {
      test('matches by item name (case-insensitive)', () {
        final state = filled().copyWith(searchQuery: 'nasi');
        expect(state.searchResults.length, 1);
        expect(state.searchResults.first.name, 'Nasi Goreng');
      });

      test('matches by item description', () {
        final state = filled().copyWith(searchQuery: 'fried noodle');
        expect(state.searchResults.length, 1);
        expect(state.searchResults.first.name, 'Mie Goreng');
      });

      test('returns empty list when query is blank', () {
        expect(filled().copyWith(searchQuery: '').searchResults, isEmpty);
      });

      test('returns empty list when data is loading', () {
        expect(const MenuState(searchQuery: 'nasi').searchResults, isEmpty);
      });
    });

    group('categoryName', () {
      test('returns the name for a known categoryId', () {
        expect(filled().categoryName(10), 'Rice');
        expect(filled().categoryName(20), 'Appetizers');
      });

      test('returns empty string for unknown categoryId', () {
        expect(filled().categoryName(999), '');
      });
    });
  });
}
