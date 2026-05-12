import 'package:cart_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_app.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('renders app bar title', (tester) async {
      await tester.pumpWidget(buildTestApp(const HomeScreen()));
      expect(find.text('Cart App'), findsOneWidget);
    });

    testWidgets('shows Scan Table QR Code button', (tester) async {
      await tester.pumpWidget(buildTestApp(const HomeScreen()));
      expect(find.text('Scan Table QR Code'), findsOneWidget);
    });

    testWidgets('shows Browse Demo Menu button', (tester) async {
      await tester.pumpWidget(buildTestApp(const HomeScreen()));
      expect(find.text('Browse Demo Menu'), findsOneWidget);
    });

    testWidgets('shows QR code scanner icon', (tester) async {
      await tester.pumpWidget(buildTestApp(const HomeScreen()));
      expect(find.byIcon(Icons.qr_code_scanner), findsWidgets);
    });

    testWidgets('shows descriptive subtitle text', (tester) async {
      await tester.pumpWidget(buildTestApp(const HomeScreen()));
      expect(
        find.text('Scan the QR code on your table to view the menu'),
        findsOneWidget,
      );
    });
  });
}
