import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/stores_providers.dart';

class StoresScreen extends ConsumerWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(storesProvider);
    final cs = Theme.of(context).colorScheme;

    return storesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (stores) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stores.length,
        itemBuilder: (_, i) {
          final store = stores[i];
          return Card(
            child: ListTile(
              title: Text(store.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: store.ratio.clamp(0, 1),
                    backgroundColor: cs.surfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${store.spent.toStringAsFixed(0)} / ${store.cap.toStringAsFixed(0)}',
                  ),
                  Text('Next due: ${store.nextDue}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
