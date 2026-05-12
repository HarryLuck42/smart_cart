import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/models.dart';

part 'menu_api_service.g.dart';

@RestApi()
abstract class MenuApiService {
  factory MenuApiService(Dio dio) = _MenuApiService;

  @GET('/api/v1/menu')
  Future<MenuResponse> getMenu(@Query('table_id') String tableId);
}
