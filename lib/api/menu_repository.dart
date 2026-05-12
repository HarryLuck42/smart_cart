import '../models/category.dart';
import '../models/menu_response.dart';
import 'menu_api_service.dart';

/// Abstracts the network layer and is the single source of truth for menu data.
class MenuRepository {
  final MenuApiService _apiService;

  const MenuRepository(this._apiService);

  Future<List<Category>> getCategories() async {
    final response = await _apiService.getCategories();
    return response.data;
  }

  Future<MenuResponse> getMenu(String tableId) =>
      _apiService.getMenu(tableId);
}
