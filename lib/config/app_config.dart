/// Compile-time configuration injected via --dart-define-from-file.
///
/// Dev:  flutter run --dart-define-from-file=env/dev.json
/// Prod: flutter run --dart-define-from-file=env/prod.json
class AppConfig {
  AppConfig._();

  static const environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'prod',
  );

  static const baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://foodorderapi-production-1555.up.railway.app',
  );

  static bool get isDev => environment == 'dev';
  static bool get isProd => environment == 'prod';
}
