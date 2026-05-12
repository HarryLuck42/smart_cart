// hide Flutter's own @Category annotation to avoid conflict with our model.
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/category.dart';
import '../../models/menu_item.dart';
import '../../models/menu_response.dart';

@immutable
class MenuState {
  final AsyncValue<MenuResponse> data;
  final AsyncValue<List<Category>> categories;
  final String searchQuery;

  const MenuState({
    this.data = const AsyncLoading(),
    this.categories = const AsyncLoading(),
    this.searchQuery = '',
  });

  MenuState copyWith({
    AsyncValue<MenuResponse>? data,
    AsyncValue<List<Category>>? categories,
    String? searchQuery,
  }) =>
      MenuState(
        data: data ?? this.data,
        categories: categories ?? this.categories,
        searchQuery: searchQuery ?? this.searchQuery,
      );

  // Categories from the dedicated API endpoint, sorted by sort_order.
  List<Category> get sortedCategories {
    final cats = categories.asData?.value;
    if (cats == null) return [];
    return List<Category>.from(cats)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  List<MenuItem> itemsForCategory(int categoryId) =>
      data.asData?.value.itemsByCategory(categoryId) ?? [];

  List<MenuItem> get allItems => data.asData?.value.items ?? [];

  List<MenuItem> get searchResults {
    final menu = data.asData?.value;
    if (menu == null || searchQuery.isEmpty) return [];
    final q = searchQuery.toLowerCase();
    return menu.items
        .where((item) =>
            item.name.toLowerCase().contains(q) ||
            item.description.toLowerCase().contains(q))
        .toList();
  }

  String categoryName(int categoryId) => sortedCategories
      .firstWhere(
        (c) => c.id == categoryId,
        orElse: () => Category(id: 0, name: '', sortOrder: 0),
      )
      .name;
}
