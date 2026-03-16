import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/inventory_providers.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(inventoryItemsProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(inventoryItemsProvider.future),
      child: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorRetry(
          message: '$err',
          onRetry: () => ref.refresh(inventoryItemsProvider),
        ),
        data: (items) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            final color = _statusColor(context, item.status);
            return Card(
              child: ListTile(
                leading: CircleAvatar(backgroundColor: color, radius: 8),
                title: Text(item.name),
                subtitle: Text('${item.qty} • ${item.expiry}'),
                trailing: Text(item.status),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _statusColor(BuildContext context, String status) {
    final cs = Theme.of(context).colorScheme;
    switch (status) {
      case 'expiring':
        return cs.tertiary;
      case 'low':
        return cs.secondary;
      case 'out':
        return cs.error;
      default:
        return cs.primary;
    }
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
