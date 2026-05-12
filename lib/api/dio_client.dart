import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class DioClient {
  static const String baseUrl =
      'https://foodorderapi-production-1555.up.railway.app';

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: false,
        responseBody: true,
        error: true,
        logPrint: (log) => debugPrint('[DioClient] $log'),
      ),
    );

    return dio;
  }
}
