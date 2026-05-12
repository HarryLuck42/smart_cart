import 'dart:async';

import 'package:cart_app/api/api_exception.dart';
import 'package:cart_app/models/order_detail.dart';
import 'package:cart_app/screens/order_tracking_screen.dart';
import 'package:cart_app/state/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_app.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/mocks.mocks.dart';

void main() {
  late MockOrderRepository mockRepo;

  setUp(() => mockRepo = MockOrderRepository());

  group('OrderTrackingScreen', () {
    testWidgets('shows loading spinner while fetch is in progress',
        (tester) async {
      when(mockRepo.getOrder('42'))
          .thenAnswer((_) => Completer<OrderDetail>().future);

      await tester.pumpWidget(
        buildTestApp(
          const OrderTrackingScreen(orderId: '42'),
          overrides: [orderRepositoryProvider.overrideWithValue(mockRepo)],
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows order status label after successful fetch',
        (tester) async {
      when(mockRepo.getOrder('42'))
          .thenAnswer((_) async => makeOrderDetail(id: 42, status: 'confirmed'));

      await tester.pumpWidget(
        buildTestApp(
          const OrderTrackingScreen(orderId: '42'),
          overrides: [orderRepositoryProvider.overrideWithValue(mockRepo)],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Order Confirmed'), findsOneWidget);
    });

    testWidgets('shows all five progress steps in the timeline',
        (tester) async {
      when(mockRepo.getOrder('1'))
          .thenAnswer((_) async => makeOrderDetail(status: 'pending'));

      await tester.pumpWidget(
        buildTestApp(
          const OrderTrackingScreen(orderId: '1'),
          overrides: [orderRepositoryProvider.overrideWithValue(mockRepo)],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Order Progress'), findsOneWidget);
      expect(find.text('Confirmed'), findsOneWidget);
      expect(find.text('Preparing'), findsOneWidget);
      expect(find.text('Served'), findsOneWidget);
    });

    testWidgets('shows error view and Retry button when fetch fails',
        (tester) async {
      when(mockRepo.getOrder('1')).thenThrow(
        const ApiException(
          code: 'NO_INTERNET',
          message: 'No internet connection. Please check your network.',
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          const OrderTrackingScreen(orderId: '1'),
          overrides: [orderRepositoryProvider.overrideWithValue(mockRepo)],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Could not load order'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows customer note card when note is present', (tester) async {
      when(mockRepo.getOrder('1')).thenAnswer(
        (_) async => makeOrderDetail(customerNote: 'No MSG please'),
      );

      await tester.pumpWidget(
        buildTestApp(
          const OrderTrackingScreen(orderId: '1'),
          overrides: [orderRepositoryProvider.overrideWithValue(mockRepo)],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No MSG please', skipOffstage: false), findsOneWidget);
    });

    testWidgets('shows Back to Home button when order is served', (tester) async {
      when(mockRepo.getOrder('1'))
          .thenAnswer((_) async => makeOrderDetail(status: 'served'));

      await tester.pumpWidget(
        buildTestApp(
          const OrderTrackingScreen(orderId: '1'),
          overrides: [orderRepositoryProvider.overrideWithValue(mockRepo)],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Back to Home', skipOffstage: false), findsOneWidget);
    });
  });
}
