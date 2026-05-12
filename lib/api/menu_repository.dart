import 'package:dio/dio.dart';
import '../models/category.dart';
import '../models/menu_response.dart';
import 'api_exception.dart';
import 'menu_api_service.dart';

/// Abstracts the network layer and is the single source of truth for menu data.
class MenuRepository {
  final MenuApiService _apiService;

  const MenuRepository(this._apiService);

  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiService.getCategories();
      return response.data;
    } on DioException catch (e) {
      throw _unwrap(e);
    }
  }

  Future<MenuResponse> getMenu(String tableId) async {
    try {
      return await _apiService.getMenu(tableId);
    } on DioException catch (e) {
      throw _unwrap(e);
    }
  }
}

ApiException _unwrap(DioException e) =>
    e.error is ApiException ? e.error as ApiException : ApiException.fromDio(e);
