import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/scanner_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/order_tracking_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const ScannerScreen(),
    ),
    GoRoute(
      path: '/menu/:tableId',
      builder: (context, state) => MenuScreen(
        tableId: state.pathParameters['tableId']!,
      ),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => CartScreen(
        tableId: state.uri.queryParameters['tableId'] ?? '',
      ),
    ),
    GoRoute(
      path: '/order/:orderId',
      builder: (context, state) => OrderTrackingScreen(
        orderId: state.pathParameters['orderId']!,
      ),
    ),
  ],
);
