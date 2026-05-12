// hide Flutter's own @Category annotation to avoid conflict with our model.
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/category.dart';
import '../../models/menu_item.dart';
import '../../models/menu_response.dart';

@immutable
class MenuState {
  final AsyncValue<MenuResponse> data;
  final String searchQuery;

  const MenuState({
    this.data = const AsyncLoading(),
    this.searchQuery = '',
  });

  MenuState copyWith({
    AsyncValue<MenuResponse>? data,
    String? searchQuery,
  }) =>
      MenuState(
        data: data ?? this.data,
        searchQuery: searchQuery ?? this.searchQuery,
      );

  List<Category> get sortedCategories {
    final menu = data.asData?.value;
    if (menu == null) return [];
    return List<Category>.from(menu.categories)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  List<MenuItem> itemsForCategory(int categoryId) =>
      data.asData?.value.itemsByCategory(categoryId) ?? [];

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
