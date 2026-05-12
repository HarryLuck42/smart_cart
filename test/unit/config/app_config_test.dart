import 'package:cart_app/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig', () {
    test('environment defaults to prod', () {
      expect(AppConfig.environment, 'prod');
    });

    test('baseUrl has a non-empty default', () {
      expect(AppConfig.baseUrl, isNotEmpty);
    });

    test('isDev is false with default environment', () {
      expect(AppConfig.isDev, isFalse);
    });

    test('isProd is true with default environment', () {
      expect(AppConfig.isProd, isTrue);
    });
  });
}
