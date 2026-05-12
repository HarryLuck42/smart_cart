import 'category.dart';
import 'menu_item.dart';
import 'restaurant.dart';

class MenuResponse {
  final String tableId;
  final Restaurant restaurant;
  final List<Category> categories;

  const MenuResponse({
    required this.tableId,
    required this.restaurant,
    required this.categories,
  });

  factory MenuResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return MenuResponse(
      tableId: data['table_id'] as String,
      restaurant: Restaurant.fromJson(data['restaurant'] as Map<String, dynamic>),
      categories: (data['categories'] as List)
          .map((c) => Category.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  List<MenuItem> get items => categories.expand((c) => c.items).toList();

  List<MenuItem> itemsByCategory(int categoryId) {
    try {
      return categories.firstWhere((c) => c.id == categoryId).items;
    } catch (_) {
      return const [];
    }
  }
}
