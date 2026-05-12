import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../state/providers.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  late final MobileScannerController _controller;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(scannerViewModelProvider.notifier).controller;
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final rawValue = capture.barcodes.firstOrNull?.rawValue;
    if (rawValue == null) return;

    final tableId =
        ref.read(scannerViewModelProvider.notifier).extractTableId(rawValue);

    if (tableId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid QR code: "$rawValue".\nPlease scan the table QR code.',
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      return;
    }

    setState(() => _hasScanned = true);
    _controller.stop();
    // Replace scanner with menu so back from menu returns to home.
    context.replace('/menu/$tableId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Table QR Code'),
        actions: [
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (_, state, _) => IconButton(
              icon: Icon(
                state.torchState == TorchState.on
                    ? Icons.flash_on
                    : Icons.flash_off,
              ),
              onPressed: _controller.toggleTorch,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (_, state, _) => IconButton(
              icon: Icon(
                state.cameraDirection == CameraFacing.front
                    ? Icons.camera_front
                    : Icons.camera_rear,
              ),
              onPressed: _controller.switchCamera,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          const _ScanOverlay(),
        ],
      ),
    );
  }
}

class _ScanOverlay extends StatelessWidget {
  const _ScanOverlay();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container(color: Colors.black54)),
        Row(
          children: [
            Expanded(child: Container(color: Colors.black54)),
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Expanded(child: Container(color: Colors.black54)),
          ],
        ),
        Expanded(
          child: Container(
            color: Colors.black54,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 16),
            child: const Text(
              'Align the table QR code within the frame',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
