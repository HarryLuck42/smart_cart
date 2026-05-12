import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/cart_item.dart';
import '../state/order/order_state.dart';
import '../state/providers.dart';

class CartScreen extends ConsumerStatefulWidget {
  final String tableId;

  const CartScreen({super.key, required this.tableId});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = ref.watch(cartViewModelProvider);
    final cartVm = ref.read(cartViewModelProvider.notifier);
    final orderState = ref.watch(orderViewModelProvider);

    ref.listen<OrderState>(orderViewModelProvider, (_, next) {
      if (next.isSuccess) {
        final orderId = next.orderId!;
        ref.read(cartViewModelProvider.notifier).clear();
        ref.read(orderViewModelProvider.notifier).reset();
        context.push('/order/$orderId');
      } else if (next.isError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(orderViewModelProvider.notifier).reset();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(
            cart.totalCount == 0 ? 'Cart' : 'Cart (${cart.totalCount})'),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => _confirmClear(context),
              child: Text(
                'Clear all',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const _EmptyCartView()
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, _) => const Divider(height: 32),
                    itemBuilder: (_, i) => _CartItemTile(
                      cartItem: cart.items[i],
                      onIncrement: () => cartVm.increment(i),
                      onDecrement: () => cartVm.decrement(i),
                      onRemove: () => cartVm.remove(i),
                    ),
                  ),
                ),
                _CartSummary(
                  subtotal: cart.subtotal,
                  noteController: _noteController,
                  isSubmitting: orderState.isSubmitting,
                  onPlaceOrder: () => ref
                      .read(orderViewModelProvider.notifier)
                      .submitOrder(
                        tableId: widget.tableId,
                        items: cart.items,
                        customerNote: _noteController.text.trim(),
                      ),
                ),
              ],
            ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('All items will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(cartViewModelProvider.notifier).clear();
              Navigator.pop(dialogContext);
            },
            child: Text(
              'Clear',
              style: TextStyle(
                  color: Theme.of(dialogContext).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }


}

// ── Cart item row ─────────────────────────────────────────────────────────────

class _CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.cartItem,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cartItem.item.name,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (cartItem.selectedOptions.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  cartItem.selectedOptions.map((o) => o.name).join(' · '),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey.shade600),
                ),
              ],
              const SizedBox(height: 6),
              Text(
                '\$${cartItem.unitPrice.toStringAsFixed(2)} each',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: onRemove,
              child: Icon(Icons.close, size: 18, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _QtyButton(icon: Icons.remove, onTap: onDecrement),
                SizedBox(
                  width: 36,
                  child: Text(
                    '${cartItem.quantity}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                _QtyButton(icon: Icons.add, onTap: onIncrement),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '\$${cartItem.totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

// ── Cart summary footer ───────────────────────────────────────────────────────

class _CartSummary extends StatelessWidget {
  final double subtotal;
  final TextEditingController noteController;
  final bool isSubmitting;
  final VoidCallback onPlaceOrder;

  const _CartSummary({
    required this.subtotal,
    required this.noteController,
    required this.isSubmitting,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Note to kitchen (optional)',
                hintText: 'e.g. No MSG, extra spicy…',
                prefixIcon: const Icon(Icons.sticky_note_2_outlined),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
              ),
              maxLines: 2,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: theme.textTheme.titleMedium),
                Text(
                  '\$${subtotal.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isSubmitting ? null : onPlaceOrder,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Text('Place Order',
                        style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text('Your cart is empty',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Add items from the menu',
              style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
