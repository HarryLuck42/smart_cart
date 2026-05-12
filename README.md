# Cart App

A Flutter-based restaurant ordering app. Customers scan the QR code on their table, browse the menu, add items to cart, place an order, and track its status in real time.

---

## Table of Contents

1. [Setup Instructions](#1-setup-instructions)
2. [Environment Configuration](#2-environment-configuration)
3. [Build APK & iOS](#3-build-apk--ios)
4. [Architecture Overview](#4-architecture-overview)
5. [Tests](#5-tests)

---

## 1. Setup Instructions

### Prerequisites

| Tool | Minimum version |
|------|----------------|
| Flutter SDK | 3.x (Dart ≥ 3.11.5) |
| Android Studio / Xcode | Latest stable |
| A connected device or emulator | — |

### Steps

```bash
# 1. Clone the repository
git clone <repo-url>
cd cart_app

# 2. Install dependencies
flutter pub get

# 3. Regenerate code (Retrofit + json_serializable)
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app (uses prod environment by default)
flutter run

# Run against a local backend (dev environment)
flutter run --dart-define-from-file=env/dev.json
```

> **Note:** Step 3 only needs to be re-run when you change files annotated with `@JsonSerializable` or `@RestApi`.

---

## 2. Environment Configuration

The app uses `--dart-define-from-file` to inject environment variables at compile time. No `.env` file is read at runtime — values are baked into the binary.

### Available environments

| File | `ENVIRONMENT` | `BASE_URL` |
|------|--------------|-----------|
| `env/dev.json` | `dev` | `http://10.0.2.2:3000` (Android emulator → localhost) |
| `env/prod.json` | `prod` | `https://foodorderapi-production-1555.up.railway.app` |

### `env/dev.json`

```json
{
  "ENVIRONMENT": "dev",
  "BASE_URL": "http://10.0.2.2:3000"
}
```

### `env/prod.json`

```json
{
  "ENVIRONMENT": "prod",
  "BASE_URL": "https://foodorderapi-production-1555.up.railway.app"
}
```

### Creating a custom environment

Create any JSON file (e.g., `env/staging.json`) with the two keys above and pass it at run/build time:

```bash
flutter run --dart-define-from-file=env/staging.json
```

### Accessing values in code

`lib/config/app_config.dart` exposes the values as compile-time constants:

```dart
AppConfig.baseUrl        // the API base URL
AppConfig.environment    // "dev" | "prod"
AppConfig.isDev          // bool
AppConfig.isProd         // bool
```

---

## 3. Build APK & iOS

### Android — debug APK

```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

### Android — release APK

```bash
# Production environment (default)
flutter build apk --release

# Or specify an environment explicitly
flutter build apk --release --dart-define-from-file=env/prod.json

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android — App Bundle (Play Store)

```bash
flutter build appbundle --release --dart-define-from-file=env/prod.json
# Output: build/app/outputs/bundle/release/app-release.aab
```

> **Signing:** For a production release you must configure a keystore in `android/key.properties` and update `android/app/build.gradle`. See the [Flutter Android release guide](https://docs.flutter.dev/deployment/android).

### iOS — release build

```bash
flutter build ios --release --dart-define-from-file=env/prod.json
```

Then open `ios/Runner.xcworkspace` in Xcode, select a provisioning profile, and archive via **Product → Archive**.

> **Requirements:** macOS with Xcode installed and a valid Apple Developer account. See the [Flutter iOS release guide](https://docs.flutter.dev/deployment/ios).

---

## 4. Architecture Overview

The project follows a layered architecture — **UI → State → Repository → API** — with each layer having a single responsibility.

```
lib/
├── api/             # Retrofit service interfaces + Dio client + error handling
├── config/          # AppConfig (compile-time env variables)
├── models/          # Plain data classes + JSON serialization (json_serializable)
├── navigation/      # GoRouter configuration
├── screens/         # One file per screen (Widget layer)
├── components/      # Reusable widgets (MenuItemCard, CustomizationSheet)
├── state/           # Riverpod providers, ViewModels, and state classes
│   ├── cart/
│   ├── menu/
│   ├── order/
│   ├── order_tracking/
│   └── scanner/
├── services/        # App-level services (OrderCacheNotifier / SharedPreferences)
└── debug/           # Talker logger (debug-only API log viewer)
```

### Key decisions

**State management — Riverpod + StateNotifier**

Each feature has a `*State` (immutable data class) and a `*ViewModel` (`StateNotifier` subclass). Providers are declared in `lib/state/providers.dart` and scoped appropriately:

- `autoDispose` for screen-scoped state (menu, order tracking) — freed when the screen leaves the widget tree.
- Long-lived (no autoDispose) for app-scoped state (cart, current order submission).
- `autoDispose.family` for parameterised providers (menu by `tableId`, tracking by `orderId`).

**Networking — Retrofit + Dio**

`DioClient.create()` builds a single `Dio` instance (exposed via `dioProvider`) shared by all API services. Two interceptors are registered:

1. Converts `{"success": false}` 2xx responses into `DioException` so they flow through the same error path as HTTP errors.
2. Parses the `{"error": {"code": ..., "message": ...}}` body into `ApiException`.

**Navigation — GoRouter**

| Route | Screen |
|-------|--------|
| `/` | HomeScreen |
| `/scanner` | ScannerScreen |
| `/menu/:tableId` | MenuScreen |
| `/cart?tableId=` | CartScreen |
| `/order/:orderId` | OrderTrackingScreen |

After a successful scan, the scanner is replaced (`context.replace`) so the back button returns to Home, not back into the scanner.

**Persistence — SharedPreferences**

`OrderCacheNotifier` (`lib/services/order_cache.dart`) stores the last placed order ID so the "Track My Order" button survives app restarts. The cache is cleared automatically when the order status reaches `served`.

**Code generation**

Run `dart run build_runner build` to regenerate:

- `*.g.dart` — JSON serializers (`json_serializable`)
- `*_api_service.g.dart` — Retrofit HTTP client implementations

---

## 5. Tests

Tests are split into two suites: **unit** and **widget**.

### Running the tests

```bash
# Run all tests
flutter test

# Run only unit tests
flutter test test/unit

# Run only widget tests
flutter test test/widget

# Run a single file
flutter test test/unit/models/menu_state_test.dart

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Unit tests (`test/unit/`)

| File | What it covers |
|------|---------------|
| `models/cart_item_test.dart` | CartItem price calculation with options |
| `models/cart_state_test.dart` | Cart subtotal, total count, add/remove logic |
| `models/menu_state_test.dart` | Sorted categories, allItems, per-category items, search results, categoryName lookup |
| `api/api_exception_test.dart` | ApiException message formatting |
| `config/app_config_test.dart` | Compile-time env variable defaults |
| `viewmodels/cart_view_model_test.dart` | Add, increment, decrement, remove, clear |
| `viewmodels/scanner_view_model_test.dart` | QR URL parsing and tableId extraction |
| `viewmodels/menu_view_model_test.dart` | Fetch success/failure, search query updates |
| `viewmodels/order_view_model_test.dart` | Order submission success and error paths |
| `viewmodels/order_tracking_view_model_test.dart` | Order fetch, polling, error handling |

### Widget tests (`test/widget/`)

| File | What it covers |
|------|---------------|
| `screens/home_screen_test.dart` | App bar title, scan button, descriptive text, Track My Order button visibility based on cached order |
| `screens/cart_screen_test.dart` | Empty cart state, item rendering, quantity controls, Clear all confirmation dialog |
| `screens/order_tracking_screen_test.dart` | Loading state, order status display, timeline progression, Back to Home button when served |
| `components/menu_item_card_test.dart` | Item name/price display, Add to Cart button, customization indicator |

### Test helpers (`test/helpers/`)

- **`fixtures.dart`** — `makeMenuResponse()`, pre-built `kTestCategoryA/B` and `kTestMenuItem*` objects used across tests.
- **`mocks.dart` / `mocks.mocks.dart`** — Mockito-generated mocks for `MenuRepository` and `OrderRepository`, keeping unit tests isolated from the network.
- **`widget/helpers/test_app.dart`** — `buildTestApp(widget)` wraps any widget in `ProviderScope` + `MaterialApp` for widget tests.
