import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/order_detail.dart';
import '../state/providers.dart';

// ── Status helpers ────────────────────────────────────────────────────────────

const _statusOrder = ['pending', 'confirmed', 'preparing', 'ready', 'served'];

String _statusLabel(String status) => switch (status) {
      'pending' => 'Order Received',
      'confirmed' => 'Order Confirmed',
      'preparing' => 'Being Prepared',
      'ready' => 'Ready to Serve!',
      'served' => 'Order Served',
      _ => status,
    };

String _statusDescription(String status) => switch (status) {
      'pending' => 'Waiting for the kitchen to accept your order…',
      'confirmed' => 'The kitchen has accepted your order.',
      'preparing' => 'The kitchen is working on your food.',
      'ready' => 'Your order is ready — a server will bring it shortly.',
      'served' => 'Enjoy your meal!',
      _ => '',
    };

IconData _statusIcon(String status) => switch (status) {
      'pending' => Icons.access_time_rounded,
      'confirmed' => Icons.thumb_up_alt_rounded,
      'preparing' => Icons.restaurant_rounded,
      'ready' => Icons.dinner_dining_rounded,
      'served' => Icons.check_circle_rounded,
      _ => Icons.info_outline_rounded,
    };

Color _statusColor(String status, BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return switch (status) {
    'pending' => Colors.amber.shade700,
    'confirmed' => cs.primary,
    'preparing' => Colors.orange.shade700,
    'ready' => Colors.green.shade600,
    'served' => Colors.green.shade800,
    _ => Colors.grey.shade600,
  };
}

// ── Screen ────────────────────────────────────────────────────────────────────

class OrderTrackingScreen extends ConsumerWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderTrackingViewModelProvider(orderId));

    ref.listen(orderTrackingViewModelProvider(orderId), (_, next) {
      if (next.order?.status == 'served') {
        ref.read(orderCacheProvider.notifier).clear();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Order #$orderId'),
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          tooltip: 'Home',
          onPressed: () => context.go('/'),
        ),
      ),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, state) {
    if (state.isLoading && state.order == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.order == null) {
      return _ErrorView(
        error: state.error!,
        onRetry: () =>
            ref.read(orderTrackingViewModelProvider(orderId).notifier).fetchOrder(),
      );
    }

    if (state.order == null) return const SizedBox.shrink();

    final order = state.order as OrderDetail;

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(orderTrackingViewModelProvider(orderId).notifier).fetchOrder(),
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.viewPaddingOf(context).bottom + 16,
        ),
        children: [
          _StatusHeader(order: order),
          const SizedBox(height: 16),
          _StatusTimeline(currentStatus: order.status),
          if (order.items.isNotEmpty) ...[
            const SizedBox(height: 16),
            _OrderItemsCard(items: order.items, totalPrice: order.totalPrice),
          ],
          if (order.customerNote?.isNotEmpty == true) ...[
            const SizedBox(height: 16),
            _NoteCard(note: order.customerNote!),
          ],
          const SizedBox(height: 24),
          _BackToMenuButton(
            isServed: order.status == 'served',
            orderId: orderId,
          ),
          // Non-intrusive background-refresh error hint
          if (state.error != null && state.order != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Could not refresh — pull down to retry.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Status header card ────────────────────────────────────────────────────────

class _StatusHeader extends StatelessWidget {
  final OrderDetail order;

  const _StatusHeader({required this.order});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(order.status, context);
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_statusIcon(order.status), size: 40, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              _statusLabel(order.status),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _statusDescription(order.status),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Progress timeline ─────────────────────────────────────────────────────────

class _StatusTimeline extends StatelessWidget {
  final String currentStatus;

  const _StatusTimeline({required this.currentStatus});

  static const _steps = [
    (status: 'pending', label: 'Order Received', icon: Icons.receipt_long_rounded),
    (status: 'confirmed', label: 'Confirmed', icon: Icons.thumb_up_alt_rounded),
    (status: 'preparing', label: 'Preparing', icon: Icons.restaurant_rounded),
    (status: 'ready', label: 'Ready to Serve', icon: Icons.dinner_dining_rounded),
    (status: 'served', label: 'Served', icon: Icons.check_circle_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = _statusOrder.indexOf(currentStatus);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Progress',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < _steps.length; i++)
              _StepRow(
                label: _steps[i].label,
                icon: _steps[i].icon,
                isDone: i < currentIndex,
                isCurrent: i == currentIndex,
                isLast: i == _steps.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDone;
  final bool isCurrent;
  final bool isLast;

  const _StepRow({
    required this.label,
    required this.icon,
    required this.isDone,
    required this.isCurrent,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final dotColor = isDone
        ? primary
        : isCurrent
            ? primary.withValues(alpha: 0.15)
            : Colors.grey.shade200;

    final dotBorderColor = isDone || isCurrent ? primary : Colors.grey.shade300;

    final dotIconColor = isDone
        ? Colors.white
        : isCurrent
            ? primary
            : Colors.grey.shade400;

    final lineColor = isDone ? primary : Colors.grey.shade200;

    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
      color: isDone || isCurrent
          ? theme.colorScheme.onSurface
          : Colors.grey.shade500,
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dot + connecting line
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: dotBorderColor, width: 2),
                  ),
                  child: Icon(
                    isDone ? Icons.check_rounded : icon,
                    size: 18,
                    color: dotIconColor,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Center(
                      child: Container(width: 2, color: lineColor),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Label
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 12 : 24, top: 6),
              child: Text(label, style: labelStyle),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Order items card ──────────────────────────────────────────────────────────

class _OrderItemsCard extends StatelessWidget {
  final List<OrderDetailItem> items;
  final double totalPrice;

  const _OrderItemsCard({required this.items, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Order',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            for (final item in items) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${item.quantity}×',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: theme.textTheme.bodyMedium),
                        if (item.customizations.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: item.customizations
                                  .map(
                                    (c) => Text(
                                      '+ ${c.optionName}'
                                      '${c.quantity > 1 ? ' ×${c.quantity}' : ''}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '\$${item.subtotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            const Divider(height: 8),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Customer note card ────────────────────────────────────────────────────────

class _NoteCard extends StatelessWidget {
  final String note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(Icons.sticky_note_2_outlined,
            color: Theme.of(context).colorScheme.secondary),
        title: const Text('Kitchen Note'),
        subtitle: Text(note),
      ),
    );
  }
}

// ── Back to menu / new order button ──────────────────────────────────────────

class _BackToMenuButton extends StatelessWidget {
  final bool isServed;
  final String orderId;

  const _BackToMenuButton({required this.isServed, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: isServed
          ? FilledButton.icon(
              icon: const Icon(Icons.home_rounded),
              label: const Text('Back to Home', style: TextStyle(fontSize: 15)),
              onPressed: () => context.go('/'),
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14)),
            )
          : OutlinedButton.icon(
              icon: const Icon(Icons.arrow_back_rounded),
              label:
                  const Text('Back to Menu', style: TextStyle(fontSize: 15)),
              onPressed: () => context.go('/'),
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('Could not load order',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
