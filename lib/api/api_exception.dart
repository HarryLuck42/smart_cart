import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String code;
  final String message;

  const ApiException({required this.code, required this.message});

  /// Fallback factory for DioExceptions not already wrapped by the interceptor.
  factory ApiException.fromDio(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          const ApiException(
            code: 'TIMEOUT',
            message: 'Request timed out. Please try again.',
          ),
        DioExceptionType.connectionError => const ApiException(
            code: 'NO_INTERNET',
            message: 'No internet connection. Please check your network.',
          ),
        DioExceptionType.badResponse => ApiException(
            code: 'HTTP_${e.response?.statusCode ?? 0}',
            message: 'Server error (${e.response?.statusCode}).',
          ),
        _ => ApiException(
            code: 'NETWORK_ERROR',
            message: e.message ?? 'A network error occurred.',
          ),
      };

  @override
  String toString() => message;
}
