import 'package:cart_app/api/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

DioException makeDio(
  DioExceptionType type, {
  int? statusCode,
  String? message,
}) =>
    DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: type,
      response: statusCode != null
          ? Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: statusCode,
            )
          : null,
      message: message,
    );

void main() {
  group('ApiException', () {
    test('toString returns message', () {
      const e = ApiException(code: 'X', message: 'Something failed');
      expect(e.toString(), 'Something failed');
    });

    group('fromDio', () {
      test('connectionTimeout → TIMEOUT', () {
        final e = ApiException.fromDio(makeDio(DioExceptionType.connectionTimeout));
        expect(e.code, 'TIMEOUT');
      });

      test('sendTimeout → TIMEOUT', () {
        final e = ApiException.fromDio(makeDio(DioExceptionType.sendTimeout));
        expect(e.code, 'TIMEOUT');
      });

      test('receiveTimeout → TIMEOUT', () {
        final e = ApiException.fromDio(makeDio(DioExceptionType.receiveTimeout));
        expect(e.code, 'TIMEOUT');
      });

      test('connectionError → NO_INTERNET', () {
        final e = ApiException.fromDio(makeDio(DioExceptionType.connectionError));
        expect(e.code, 'NO_INTERNET');
      });

      test('badResponse → HTTP_<statusCode>', () {
        final e = ApiException.fromDio(
            makeDio(DioExceptionType.badResponse, statusCode: 404));
        expect(e.code, 'HTTP_404');
        expect(e.message, contains('404'));
      });

      test('badResponse with no response object → HTTP_0', () {
        final e = ApiException.fromDio(makeDio(DioExceptionType.badResponse));
        expect(e.code, 'HTTP_0');
      });

      test('unknown type → NETWORK_ERROR with original message', () {
        final e = ApiException.fromDio(
            makeDio(DioExceptionType.unknown, message: 'Socket closed'));
        expect(e.code, 'NETWORK_ERROR');
        expect(e.message, 'Socket closed');
      });

      test('unknown type with null message → fallback message', () {
        final e = ApiException.fromDio(makeDio(DioExceptionType.unknown));
        expect(e.code, 'NETWORK_ERROR');
        expect(e.message, isNotEmpty);
      });
    });
  });
}
