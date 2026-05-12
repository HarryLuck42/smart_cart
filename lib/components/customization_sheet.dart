import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customization_group.dart';
import '../models/customization_option.dart';
import '../models/menu_item.dart';
import '../state/providers.dart';

class CustomizationSheet extends ConsumerStatefulWidget {
  final MenuItem item;

  const CustomizationSheet({super.key, required this.item});

  /// Opens the customization sheet if the item has groups, otherwise adds
  /// directly to cart and shows a confirmation SnackBar.
  static Future<void> show(
      BuildContext context, WidgetRef ref, MenuItem item) {
    if (item.customizationGroups.isEmpty) {
      ref.read(cartViewModelProvider.notifier).add(item, const []);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} added to cart'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return Future.value();
    }

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CustomizationSheet(item: item),
    );
  }

  @override
  ConsumerState<CustomizationSheet> createState() =>
      _CustomizationSheetState();
}

class _CustomizationSheetState extends ConsumerState<CustomizationSheet> {
  late final Map<int, Set<int>> _selections;

  @override
  void initState() {
    super.initState();
    _selections = {
      for (final g in widget.item.customizationGroups) g.id: {},
    };
  }

  bool get _canConfirm => widget.item.customizationGroups
      .where((g) => g.required)
      .every((g) => _selections[g.id]!.isNotEmpty);

  List<CustomizationOption> get _selectedOptions {
    final result = <CustomizationOption>[];
    for (final group in widget.item.customizationGroups) {
      final ids = _selections[group.id]!;
      result.addAll(group.options.where((o) => ids.contains(o.id)));
    }
    return result;
  }

  double get _totalPrice =>
      widget.item.price +
      _selectedOptions.fold(0.0, (s, o) => s + o.priceModifier);

  void _toggle(CustomizationGroup group, CustomizationOption option) {
    setState(() {
      final set = _selections[group.id]!;
      if (group.maxSelections == 1) {
        if (set.contains(option.id) && !group.required) {
          set.clear();
        } else {
          set
            ..clear()
            ..add(option.id);
        }
      } else {
        if (set.contains(option.id)) {
          set.remove(option.id);
        } else if (set.length < group.maxSelections) {
          set.add(option.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.item.description,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '\$${_totalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 24),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              children: widget.item.customizationGroups
                  .map((group) => _GroupSection(
                        group: group,
                        selectedIds: _selections[group.id]!,
                        onToggle: (opt) => _toggle(group, opt),
                      ))
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _canConfirm
                    ? () {
                        ref
                            .read(cartViewModelProvider.notifier)
                            .add(widget.item, _selectedOptions);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('${widget.item.name} added to cart'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Add to Cart  ·  \$${_totalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupSection extends StatelessWidget {
  final CustomizationGroup group;
  final Set<int> selectedIds;
  final ValueChanged<CustomizationOption> onToggle;

  const _GroupSection({
    required this.group,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  group.name,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (group.required)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    'Required',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Text(
                  'Optional',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
                ),
            ],
          ),
          if (group.maxSelections > 1)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Choose up to ${group.maxSelections}',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
              ),
            ),
          const SizedBox(height: 8),
          ...group.options.map((option) {
            final isSelected = selectedIds.contains(option.id);
            final isAtMax = group.maxSelections > 1 &&
                !isSelected &&
                selectedIds.length >= group.maxSelections;
            return _OptionTile(
              option: option,
              isSingleSelect: group.maxSelections == 1,
              isSelected: isSelected,
              isDisabled: isAtMax,
              onTap: () => onToggle(option),
            );
          }),
          const Divider(height: 24),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final CustomizationOption option;
  final bool isSingleSelect;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const _OptionTile({
    required this.option,
    required this.isSingleSelect,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final dimColor = Colors.grey.shade400;

    final priceLabel = option.priceModifier > 0
        ? '+\$${option.priceModifier.toStringAsFixed(2)}'
        : 'free';
    final semanticLabel =
        '${option.name}, $priceLabel${isSelected ? ', selected' : ''}${isDisabled ? ', unavailable' : ''}';

    return Semantics(
      label: semanticLabel,
      checked: isSelected,
      enabled: !isDisabled,
      button: true,
      excludeSemantics: true,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(
                isSingleSelect
                    ? (isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked)
                    : (isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank),
                color: isSelected ? activeColor : dimColor,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option.name,
                  style: TextStyle(
                    color: isDisabled ? dimColor : Colors.black87,
                  ),
                ),
              ),
              if (option.priceModifier > 0)
                Text(
                  '+\$${option.priceModifier.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDisabled ? dimColor : activeColor,
                    fontWeight: FontWeight.w500,
                  ),
                )
              else
                Text(
                  'Free',
                  style: theme.textTheme.bodySmall?.copyWith(color: dimColor),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
