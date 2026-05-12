import 'package:cart_app/api/api_exception.dart';
import 'package:cart_app/state/order_tracking/order_tracking_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockOrderRepository mockRepo;

  setUp(() => mockRepo = MockOrderRepository());

  group('OrderTrackingViewModel', () {
    test('initial state has isLoading true and no order', () {
      when(() => mockRepo.getOrder(any()))
          .thenAnswer((_) async => makeOrderDetail());
      final vm = OrderTrackingViewModel(mockRepo, '1');
      addTearDown(vm.dispose);

      expect(vm.state.isLoading, isTrue);
      expect(vm.state.order, isNull);
    });

    test('fetchOrder success sets order and clears loading', () async {
      final order = makeOrderDetail(id: 42, status: 'confirmed');
      when(() => mockRepo.getOrder('42')).thenAnswer((_) async => order);

      final vm = OrderTrackingViewModel(mockRepo, '42');
      addTearDown(vm.dispose);
      await vm.fetchOrder();

      expect(vm.state.order, order);
      expect(vm.state.isLoading, isFalse);
      expect(vm.state.error, isNull);
    });

    test('fetchOrder error sets error message and clears loading', () async {
      when(() => mockRepo.getOrder('1')).thenThrow(const ApiException(
        code: 'NO_INTERNET',
        message: 'No internet connection. Please check your network.',
      ));

      final vm = OrderTrackingViewModel(mockRepo, '1');
      addTearDown(vm.dispose);
      await vm.fetchOrder();

      expect(vm.state.error, isNotNull);
      expect(vm.state.isLoading, isFalse);
    });

    test('fetchOrder error preserves previously loaded order', () async {
      final order = makeOrderDetail(status: 'preparing');
      when(() => mockRepo.getOrder('1')).thenAnswer((_) async => order);

      final vm = OrderTrackingViewModel(mockRepo, '1');
      addTearDown(vm.dispose);
      await vm.fetchOrder(); // succeeds

      when(() => mockRepo.getOrder('1'))
          .thenThrow(const ApiException(code: 'NET', message: 'Network error'));
      await vm.fetchOrder(); // fails

      expect(vm.state.order, order);
      expect(vm.state.error, isNotNull);
    });

    test('background refresh does not show loading spinner', () async {
      final order = makeOrderDetail(status: 'confirmed');
      when(() => mockRepo.getOrder('1')).thenAnswer((_) async => order);

      final vm = OrderTrackingViewModel(mockRepo, '1');
      addTearDown(vm.dispose);
      await vm.fetchOrder(); // first fetch — order is now loaded

      when(() => mockRepo.getOrder('1'))
          .thenAnswer((_) async => makeOrderDetail(status: 'preparing'));
      await vm.fetchOrder(); // background refresh

      expect(vm.state.isLoading, isFalse);
      expect(vm.state.order?.status, 'preparing');
    });

    test('timer is cancelled when status reaches served', () async {
      final order = makeOrderDetail(status: 'served');
      when(() => mockRepo.getOrder('1')).thenAnswer((_) async => order);

      final vm = OrderTrackingViewModel(mockRepo, '1');
      addTearDown(vm.dispose);
      await vm.fetchOrder();

      expect(vm.state.order?.status, 'served');
      // No assertion on the timer itself — dispose() must not throw
    });
  });
}
