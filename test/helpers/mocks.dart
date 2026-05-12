import 'package:cart_app/api/menu_repository.dart';
import 'package:cart_app/api/order_repository.dart';
import 'package:cart_app/models/cart_item.dart';
import 'package:mocktail/mocktail.dart';

class MockMenuRepository extends Mock implements MenuRepository {}

class MockOrderRepository extends Mock implements OrderRepository {}

void setUpFallbacks() {
  registerFallbackValue(<CartItem>[]);
}
