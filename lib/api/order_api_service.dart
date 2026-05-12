import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/order_detail.dart';
import '../models/order_response.dart';

part 'order_api_service.g.dart';

@RestApi()
abstract class OrderApiService {
  factory OrderApiService(Dio dio) = _OrderApiService;

  @POST('/api/v1/orders')
  Future<OrderResponse> submitOrder(@Body() Map<String, dynamic> body);

  @GET('/api/v1/orders/{orderId}')
  Future<GetOrderResponse> getOrder(@Path('orderId') String orderId);
}
