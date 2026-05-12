import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/models.dart';

part 'menu_api_service.g.dart';

@RestApi(baseUrl: 'https://foodorderapi-production-1555.up.railway.app')
abstract class MenuApiService {
  factory MenuApiService(Dio dio, {String baseUrl}) = _MenuApiService;

  @GET('/api/v1/categories')
  Future<CategoriesResponse> getCategories();

  @GET('/api/v1/menu')
  Future<MenuResponse> getMenu(@Query('table_id') String tableId);
}
