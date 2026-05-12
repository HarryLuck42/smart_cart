import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';
import 'customization_sheet.dart';

class MenuItemCard extends ConsumerWidget {
  final MenuItem item;
  final String? categoryLabel;

  const MenuItemCard({super.key, required this.item, this.categoryLabel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.imageUrl != null)
            _NetworkImage(url: item.imageUrl!, semanticLabel: item.name),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.imageUrl == null) ...[
                  ExcludeSemantics(child: _PlaceholderImage()),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (categoryLabel != null)
                        _CategoryLabel(label: categoryLabel!),
                      Text(
                        item.name,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey.shade600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.customizationGroups.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: item.customizationGroups
                              .map((g) => _CustomizationBadge(
                                    label: g.name,
                                    isRequired: g.required,
                                  ))
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Semantics(
                            label: 'Add ${item.name} to cart',
                            button: true,
                            child: FilledButton.tonal(
                              onPressed: () =>
                                  CustomizationSheet.show(context, ref, item),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 0),
                                minimumSize: const Size(48, 48),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add, size: 16),
                                  SizedBox(width: 4),
                                  Text('Add'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkImage extends StatelessWidget {
  final String url;
  final String semanticLabel;
  const _NetworkImage({required this.url, required this.semanticLabel});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
      semanticLabel: semanticLabel,
      errorBuilder: (_, _, _) => const SizedBox.shrink(),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 80,
        height: 80,
        color: Colors.grey.shade100,
        child: Icon(Icons.restaurant, size: 32, color: Colors.grey.shade400),
      ),
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  final String label;
  const _CategoryLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
      ),
    );
  }
}

class _CustomizationBadge extends StatelessWidget {
  final String label;
  final bool isRequired;

  const _CustomizationBadge({required this.label, required this.isRequired});

  @override
  Widget build(BuildContext context) {
    final color = isRequired ? Colors.orange.shade700 : Colors.grey.shade600;
    final bgColor = isRequired ? Colors.orange.shade50 : Colors.grey.shade100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        isRequired ? '$label *' : label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
