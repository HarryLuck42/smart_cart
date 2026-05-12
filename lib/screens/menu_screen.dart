import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../state/providers.dart';
import '../components/menu_item_card.dart';

class MenuScreen extends ConsumerWidget {
  final String tableId;

  const MenuScreen({super.key, required this.tableId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(menuViewModelProvider(tableId));

    return state.data.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text('Table $tableId')),
        body: const _LoadingView(),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Menu')),
        body: _ErrorView(
          error: error.toString(),
          onRetry: () =>
              ref.read(menuViewModelProvider(tableId).notifier).fetchMenu(),
        ),
      ),
      data: (menu) => Scaffold(
        appBar: _MenuAppBar(restaurant: menu.restaurant),
        body: _MenuView(tableId: tableId),
      ),
    );
  }
}

// ── Menu view: tabs + search ──────────────────────────────────────────────────

class _MenuView extends ConsumerStatefulWidget {
  final String tableId;

  const _MenuView({required this.tableId});

  @override
  ConsumerState<_MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends ConsumerState<_MenuView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(menuViewModelProvider(widget.tableId));
    final vm = ref.read(menuViewModelProvider(widget.tableId).notifier);
    final categories = state.sortedCategories;
    final isSearching = state.searchQuery.isNotEmpty;
    final theme = Theme.of(context);

    if (categories.isEmpty) {
      return const _EmptyView(
        icon: Icons.no_food,
        message: 'No menu categories available',
      );
    }

    return DefaultTabController(
      key: ValueKey(categories.length),
      length: categories.length,
      child: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search menu…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: isSearching
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          vm.setSearchQuery('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (v) => vm.setSearchQuery(v.trim()),
            ),
          ),

          // ── Category tabs (hidden while searching) ──────────────────────────
          if (!isSearching) ...[
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: categories
                  .map((c) => Tab(
                        text:
                            '${c.name} (${state.itemsForCategory(c.id).length})',
                      ))
                  .toList(),
            ),
            const Divider(height: 1),
          ],

          // ── Content ─────────────────────────────────────────────────────────
          Expanded(
            child: isSearching
                ? _SearchResultsView(
                    results: state.searchResults,
                    query: state.searchQuery,
                    categoryNameOf: state.categoryName,
                  )
                : TabBarView(
                    children: categories
                        .map((c) => _CategoryItemList(
                              items: state.itemsForCategory(c.id),
                            ))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Category tab content ──────────────────────────────────────────────────────

class _CategoryItemList extends StatelessWidget {
  final List<MenuItem> items;

  const _CategoryItemList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _EmptyView(
        icon: Icons.no_food,
        message: 'No items in this category',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) => MenuItemCard(item: items[i]),
    );
  }
}

// ── Search results ────────────────────────────────────────────────────────────

class _SearchResultsView extends StatelessWidget {
  final List<MenuItem> results;
  final String query;
  final String Function(int categoryId) categoryNameOf;

  const _SearchResultsView({
    required this.results,
    required this.query,
    required this.categoryNameOf,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return _EmptyView(
        icon: Icons.search_off,
        message: 'No items found for "$query"',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) => MenuItemCard(
        item: results[i],
        categoryLabel: categoryNameOf(results[i].categoryId),
      ),
    );
  }
}

// ── AppBar ────────────────────────────────────────────────────────────────────

class _MenuAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final Restaurant restaurant;

  const _MenuAppBar({required this.restaurant});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cartCount = ref.watch(cartTotalCountProvider);

    return AppBar(
      backgroundColor: theme.colorScheme.inversePrimary,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            'Table ${restaurant.tableId}',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Badge.count(
            count: cartCount,
            isLabelVisible: cartCount > 0,
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          onPressed: () => context.push('/cart'),
        ),
      ],
    );
  }
}

// ── Shared states ─────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading menu…'),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('Failed to load menu',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyView({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
