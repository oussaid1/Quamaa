import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/shopping_controllers.dart';
import 'widgets/shopping_tile.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ['الكل', 'منخفض', 'نفد', 'منتهي قريبًا', 'المتجر'];
    final state = ref.watch(shoppingControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 56,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) => FilterChip(
              label: Text(filters[i]),
              selected: i == 0,
              onSelected: (_) {},
            ),
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: filters.length,
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(shoppingControllerProvider.notifier).refresh(),
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => _ErrorRetry(
                message: '$err',
                onRetry: () =>
                    ref.read(shoppingControllerProvider.notifier).refresh(),
              ),
              data: (items) => ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  const _StoreHeader('كارفور'),
                  ...items
                      .take(3)
                      .map(
                        (item) => ShoppingTile(
                          item,
                          onToggleAutoAdd: (val) => ref
                              .read(shoppingControllerProvider.notifier)
                              .updateAutoAdd(item.id, val),
                          onDelete: () => ref
                              .read(shoppingControllerProvider.notifier)
                              .deleteItem(item.id),
                        ),
                      ),
                  const SizedBox(height: 12),
                  const _StoreHeader('بقالة الحي'),
                  ...items
                      .skip(3)
                      .map(
                        (item) => ShoppingTile(
                          item,
                          onToggleAutoAdd: (val) => ref
                              .read(shoppingControllerProvider.notifier)
                              .updateAutoAdd(item.id, val),
                          onDelete: () => ref
                              .read(shoppingControllerProvider.notifier)
                              .deleteItem(item.id),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () =>
                ref.read(shoppingControllerProvider.notifier).addDemoItem(),
            icon: const Icon(Icons.add),
            label: const Text('Add item (demo/optimistic)'),
          ),
        ),
      ],
    );
  }
}

class _StoreHeader extends StatelessWidget {
  const _StoreHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 8),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
