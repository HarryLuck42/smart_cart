import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'api_exception.dart';

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

    // ── API error interceptor ─────────────────────────────────────────────────
    // onResponse: converts {"success": false} 2xx responses to DioException so
    //   they flow through the same error path as HTTP 4xx/5xx errors.
    // onError: parses the {"error": {"code": ..., "message": ...}} body from
    //   bad responses and injects ApiException into DioException.error.
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          final data = response.data;
          if (data is Map<String, dynamic> && data['success'] == false) {
            handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
              ),
            );
            return;
          }
          handler.next(response);
        },
        onError: (error, handler) {
          // Already wrapped — prevent double-processing.
          if (error.error is ApiException) {
            handler.next(error);
            return;
          }
          if (error.type == DioExceptionType.badResponse) {
            final data = error.response?.data;
            if (data is Map<String, dynamic>) {
              final err = data['error'];
              if (err is Map<String, dynamic>) {
                handler.reject(
                  error.copyWith(
                    error: ApiException(
                      code: err['code']?.toString() ?? 'HTTP_ERROR',
                      message:
                          err['message']?.toString() ?? 'Request failed.',
                    ),
                  ),
                );
                return;
              }
            }
          }
          handler.next(error);
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
