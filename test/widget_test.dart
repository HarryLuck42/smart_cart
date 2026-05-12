import 'package:cart_app/screens/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'widget/helpers/test_app.dart';

void main() {
  testWidgets('app smoke test — home screen renders', (tester) async {
    await tester.pumpWidget(buildTestApp(const HomeScreen()));
    expect(find.text('Cart App'), findsOneWidget);
  });
}
