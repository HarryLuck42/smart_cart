import 'package:dio/dio.dart';
import '../models/menu_response.dart';
import 'api_exception.dart';
import 'menu_api_service.dart';

class MenuRepository {
  final MenuApiService _apiService;

  const MenuRepository(this._apiService);

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
