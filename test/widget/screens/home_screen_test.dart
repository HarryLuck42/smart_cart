import 'package:cart_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/test_app.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('renders app bar title', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(buildTestApp(const HomeScreen()));
      expect(find.text('Cart App'), findsOneWidget);
    });

    testWidgets('shows Scan Table QR Code button', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(buildTestApp(const HomeScreen()));
      expect(find.text('Scan Table QR Code'), findsOneWidget);
    });

    testWidgets('shows QR code scanner icon', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(buildTestApp(const HomeScreen()));
      expect(find.byIcon(Icons.qr_code_scanner), findsWidgets);
    });

    testWidgets('shows descriptive subtitle text', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(buildTestApp(const HomeScreen()));
      expect(
        find.text('Scan the QR code on your table to view the menu'),
        findsOneWidget,
      );
    });

    testWidgets('hides Track My Order button when no cached order',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(buildTestApp(const HomeScreen()));
      await tester.pump();
      expect(find.textContaining('Track Order'), findsNothing);
    });

    testWidgets('shows Track My Order button when a cached order exists',
        (tester) async {
      SharedPreferences.setMockInitialValues({'last_order_id': '42'});
      await tester.pumpWidget(buildTestApp(const HomeScreen()));
      await tester.pump();
      expect(find.text('Track Order #42'), findsOneWidget);
    });
  });
}
