import 'package:flutter/foundation.dart';
import 'customization_option.dart';
import 'menu_item.dart';

@immutable
class CartItem {
  final MenuItem item;
  final List<CustomizationOption> selectedOptions;
  final int quantity;

  const CartItem({
    required this.item,
    required this.selectedOptions,
    this.quantity = 1,
  });

  CartItem copyWith({int? quantity}) => CartItem(
        item: item,
        selectedOptions: selectedOptions,
        quantity: quantity ?? this.quantity,
      );

  double get unitPrice =>
      item.price +
      selectedOptions.fold(0.0, (sum, o) => sum + o.priceModifier);

  double get totalPrice => unitPrice * quantity;

  String get key {
    final ids = (selectedOptions.map((o) => o.id).toList()..sort()).join(',');
    return '${item.id}_$ids';
  }
}
