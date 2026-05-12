import 'package:cart_app/api/api_exception.dart';
import 'package:cart_app/state/order/order_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/mocks.mocks.dart';

void main() {
  late MockOrderRepository mockRepo;

  setUp(() => mockRepo = MockOrderRepository());

  group('OrderViewModel', () {
    test('initial state is idle', () {
      expect(OrderViewModel(mockRepo).state.isIdle, isTrue);
    });

    test('submitOrder success sets orderId', () async {
      when(mockRepo.submitOrder(
        tableId: anyNamed('tableId'),
        items: anyNamed('items'),
        customerNote: anyNamed('customerNote'),
      )).thenAnswer((_) async => '42');

      final vm = OrderViewModel(mockRepo);
      await vm.submitOrder(
        tableId: 'T001',
        items: [makeCartItem()],
        customerNote: '',
      );

      expect(vm.state.isSuccess, isTrue);
      expect(vm.state.orderId, '42');
    });

    test('submitOrder failure sets errorMessage', () async {
      when(mockRepo.submitOrder(
        tableId: anyNamed('tableId'),
        items: anyNamed('items'),
        customerNote: anyNamed('customerNote'),
      )).thenThrow(const ApiException(
        code: 'API_ERROR',
        message: 'Order submission failed.',
      ));

      final vm = OrderViewModel(mockRepo);
      await vm.submitOrder(
        tableId: 'T001',
        items: [makeCartItem()],
        customerNote: '',
      );

      expect(vm.state.isError, isTrue);
      expect(vm.state.errorMessage, 'Order submission failed.');
    });

    test('reset returns state to idle after success', () async {
      when(mockRepo.submitOrder(
        tableId: anyNamed('tableId'),
        items: anyNamed('items'),
        customerNote: anyNamed('customerNote'),
      )).thenAnswer((_) async => '42');

      final vm = OrderViewModel(mockRepo);
      await vm.submitOrder(tableId: 'T001', items: [], customerNote: '');
      vm.reset();

      expect(vm.state.isIdle, isTrue);
    });

    test('second submitOrder is ignored while first is in progress', () async {
      var callCount = 0;
      when(mockRepo.submitOrder(
        tableId: anyNamed('tableId'),
        items: anyNamed('items'),
        customerNote: anyNamed('customerNote'),
      )).thenAnswer((_) async {
        callCount++;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return '42';
      });

      final vm = OrderViewModel(mockRepo);
      final first = vm.submitOrder(tableId: 'T001', items: [], customerNote: '');
      final second = vm.submitOrder(tableId: 'T001', items: [], customerNote: '');
      await Future.wait([first, second]);

      expect(callCount, 1);
    });
  });
}
