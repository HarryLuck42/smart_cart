import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/menu_repository.dart';
import 'menu_state.dart';

class MenuViewModel extends StateNotifier<MenuState> {
  final MenuRepository _repository;
  final String _tableId;

  MenuViewModel(this._repository, this._tableId) : super(const MenuState()) {
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    state = state.copyWith(data: const AsyncLoading());
    state = state.copyWith(
      data: await AsyncValue.guard(() => _repository.getMenu(_tableId)),
    );
  }

  void setSearchQuery(String query) =>
      state = state.copyWith(searchQuery: query);
}
