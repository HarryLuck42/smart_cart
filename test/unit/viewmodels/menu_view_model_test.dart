import 'package:cart_app/state/menu/menu_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/mocks.mocks.dart';

void main() {
  late MockMenuRepository mockRepo;

  setUp(() {
    mockRepo = MockMenuRepository();
    when(mockRepo.getMenu('T001')).thenAnswer((_) async => makeMenuResponse());
    when(mockRepo.getCategories()).thenAnswer((_) async => [kTestCategoryA]);
  });

  group('MenuViewModel', () {
    test('fetchMenu sets data and categories to AsyncData on success', () async {
      final vm = MenuViewModel(mockRepo, 'T001');
      await vm.fetchMenu();

      expect(vm.state.data, isA<AsyncData>());
      expect(vm.state.categories, isA<AsyncData>());
    });

    test('fetchMenu sets data to AsyncError when menu fetch fails', () async {
      when(mockRepo.getMenu('T001')).thenThrow(Exception('Network error'));

      final vm = MenuViewModel(mockRepo, 'T001');
      await vm.fetchMenu();

      expect(vm.state.data, isA<AsyncError>());
    });

    test('fetchMenu sets categories to AsyncError when categories fetch fails',
        () async {
      when(mockRepo.getCategories()).thenThrow(Exception('Network error'));

      final vm = MenuViewModel(mockRepo, 'T001');
      await vm.fetchMenu();

      expect(vm.state.categories, isA<AsyncError>());
    });

    test('setSearchQuery updates searchQuery in state', () {
      final vm = MenuViewModel(mockRepo, 'T001');
      vm.setSearchQuery('nasi');
      expect(vm.state.searchQuery, 'nasi');
    });

    test('setSearchQuery clears query when empty string provided', () {
      final vm = MenuViewModel(mockRepo, 'T001');
      vm.setSearchQuery('nasi');
      vm.setSearchQuery('');
      expect(vm.state.searchQuery, '');
    });
  });
}
