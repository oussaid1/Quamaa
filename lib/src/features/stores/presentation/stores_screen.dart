import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/stores_providers.dart';

class StoresScreen extends ConsumerWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(storesProvider);
    final cs = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(storesProvider.future),
      child: storesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorRetry(
          message: '$err',
          onRetry: () => ref.refresh(storesProvider),
        ),
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
      ),
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
