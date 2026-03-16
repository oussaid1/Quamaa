import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/inventory_providers.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(inventoryItemsProvider);
    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
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
