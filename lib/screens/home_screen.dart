import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../debug/talker_logger.dart';
import '../state/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lastOrderId = ref.watch(orderCacheProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: const Text('Cart App'),
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.bug_report_outlined),
              tooltip: 'API Logs',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TalkerScreen(talker: talker),
                ),
              ),
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: 96,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Scan the QR code on your table to view the menu',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 40),
              FilledButton.icon(
                onPressed: () => context.push('/scanner'),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan Table QR Code'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              if (lastOrderId != null) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => context.push('/order/$lastOrderId'),
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: Text('Track Order #$lastOrderId'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
