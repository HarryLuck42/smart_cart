import 'package:cart_app/state/scanner/scanner_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ScannerViewModel vm;

  setUp(() => vm = ScannerViewModel());
  tearDown(() => vm.dispose());

  group('ScannerViewModel.extractTableId', () {
    group('plain table ID', () {
      test('returns T-prefix code matching T+digits pattern', () {
        expect(vm.extractTableId('T001'), 'T001');
        expect(vm.extractTableId('T123'), 'T123');
        expect(vm.extractTableId('T9'), 'T9');
      });

      test('trims surrounding whitespace', () {
        expect(vm.extractTableId('  T001  '), 'T001');
      });

      test('returns null for lowercase t-prefix', () {
        expect(vm.extractTableId('t001'), isNull);
      });
    });

    group('URL with table_id query parameter', () {
      test('extracts tableId from a simple URL', () {
        expect(
          vm.extractTableId('https://example.com?table_id=T001'),
          'T001',
        );
      });

      test('extracts tableId when other query params are present', () {
        expect(
          vm.extractTableId('https://example.com/menu?table_id=T42&foo=bar'),
          'T42',
        );
      });

      test('returns null for URL without table_id param', () {
        expect(vm.extractTableId('https://example.com?foo=bar'), isNull);
      });

      test('returns null for URL with empty table_id value', () {
        expect(vm.extractTableId('https://example.com?table_id='), isNull);
      });
    });

    group('invalid input', () {
      test('returns null for random text', () {
        expect(vm.extractTableId('hello world'), isNull);
      });

      test('returns null for empty string', () {
        expect(vm.extractTableId(''), isNull);
      });

      test('returns null for digits-only string', () {
        expect(vm.extractTableId('001'), isNull);
      });
    });
  });
}
