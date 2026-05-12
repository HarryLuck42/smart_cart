import 'package:cart_app/models/cart_item.dart';
import 'package:cart_app/models/category.dart';
import 'package:cart_app/models/customization_option.dart';
import 'package:cart_app/models/menu_item.dart';
import 'package:cart_app/models/menu_response.dart';
import 'package:cart_app/models/order_detail.dart';
import 'package:cart_app/models/restaurant.dart';

const kTestMenuItem = MenuItem(
  id: 1,
  name: 'Nasi Goreng',
  description: 'Fried rice with egg',
  price: 12.00,
  categoryId: 10,
  customizationGroups: [],
);

const kTestMenuItemB = MenuItem(
  id: 2,
  name: 'Mie Goreng',
  description: 'Fried noodle with vegetables',
  price: 10.00,
  categoryId: 20,
  customizationGroups: [],
);

const kTestOption = CustomizationOption(
  id: 1,
  name: 'Extra Spicy',
  priceModifier: 1.50,
);

const kTestCategoryA = Category(
  id: 10,
  name: 'Rice',
  sortOrder: 2,
  items: [kTestMenuItem],
);
const kTestCategoryB = Category(
  id: 20,
  name: 'Appetizers',
  sortOrder: 1,
  items: [kTestMenuItemB],
);

MenuResponse makeMenuResponse({
  List<Category>? categories,
  String tableId = 'T001',
}) =>
    MenuResponse(
      tableId: tableId,
      restaurant: const Restaurant(id: 'R1', name: 'Test Restaurant'),
      categories: categories ?? const [kTestCategoryA],
    );

OrderDetail makeOrderDetail({
  int id = 1,
  String status = 'pending',
  String tableId = 'T001',
  double totalPrice = 12.00,
  List<OrderDetailItem>? items,
  String? customerNote,
}) =>
    OrderDetail(
      id: id,
      tableId: tableId,
      status: status,
      totalPrice: totalPrice,
      items: items ?? const [],
      customerNote: customerNote,
    );

OrderDetailItem makeOrderDetailItem({
  int id = 1,
  String name = 'Nasi Goreng',
  int quantity = 2,
  double unitPrice = 12.00,
  double subtotal = 24.00,
}) =>
    OrderDetailItem(
      id: id,
      menuItemId: 1,
      name: name,
      quantity: quantity,
      unitPrice: unitPrice,
      subtotal: subtotal,
    );

CartItem makeCartItem({
  MenuItem item = kTestMenuItem,
  List<CustomizationOption> options = const [],
  int quantity = 1,
}) =>
    CartItem(item: item, selectedOptions: options, quantity: quantity);
