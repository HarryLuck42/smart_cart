import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Widget buildTestApp(
  Widget child, {
  List<Override> overrides = const [],
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, _) => child),
      GoRoute(path: '/scanner', builder: (_, _) => const Scaffold()),
      GoRoute(path: '/menu/:tableId', builder: (_, _) => const Scaffold()),
      GoRoute(path: '/cart', builder: (_, _) => const Scaffold()),
      GoRoute(path: '/order/:orderId', builder: (_, _) => const Scaffold()),
    ],
  );
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(routerConfig: router),
  );
}
