import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/order_response.dart';

part 'order_api_service.g.dart';

@RestApi(baseUrl: 'https://foodorderapi-production-1555.up.railway.app')
abstract class OrderApiService {
  factory OrderApiService(Dio dio, {String baseUrl}) = _OrderApiService;

  @POST('/api/v1/orders')
  Future<OrderResponse> submitOrder(@Body() Map<String, dynamic> body);
}
