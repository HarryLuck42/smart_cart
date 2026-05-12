import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/models.dart';

part 'menu_api_service.g.dart';

@RestApi(baseUrl: 'https://private-cb316d-harrysubang.apiary-mock.com')
abstract class MenuApiService {
  factory MenuApiService(Dio dio, {String baseUrl}) = _MenuApiService;

  @GET('/api/v1/menu')
  Future<MenuResponse> getMenu(@Query('table_id') String tableId);
}
