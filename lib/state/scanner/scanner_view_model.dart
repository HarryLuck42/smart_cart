import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'scanner_state.dart';

class ScannerViewModel extends StateNotifier<ScannerState> {
  final MobileScannerController controller = MobileScannerController();

  ScannerViewModel() : super(const ScannerState());

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Returns the table ID extracted from [raw], or null if invalid.
  /// Accepts a plain table ID (e.g. "T001") or a URL with ?table_id=T001.
  String? extractTableId(String raw) {
    final value = raw.trim();

    final uri = Uri.tryParse(value);
    if (uri != null && uri.queryParameters.containsKey('table_id')) {
      final id = uri.queryParameters['table_id'];
      if (id != null && id.isNotEmpty) return id;
    }

    if (RegExp(r'^T\d+$').hasMatch(value)) return value;

    return null;
  }
}
