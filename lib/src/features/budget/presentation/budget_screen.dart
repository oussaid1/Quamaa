import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/budget_controller.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(budgetControllerProvider);
    final cs = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () => ref.read(budgetControllerProvider.notifier).refresh(),
      child: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorRetry(
          message: '$err',
          onRetry: () => ref.read(budgetControllerProvider.notifier).refresh(),
        ),
        data: (summary) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Cap',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${summary.spent.toStringAsFixed(0)} / ${summary.monthlyCap.toStringAsFixed(0)}',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 72,
                      width: 72,
                      child: CircularProgressIndicator(
                        value: summary.ratio.clamp(0, 1),
                        strokeWidth: 8,
                        color: cs.primary,
                        backgroundColor: cs.surfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...summary.categories.map(
              (cat) => Card(
                child: ListTile(
                  title: Text(cat.name),
                  subtitle: LinearProgressIndicator(
                    value: cat.cap == 0 ? 0 : cat.spent / cat.cap,
                    backgroundColor: cs.surfaceVariant,
                  ),
                  trailing: Text(
                    '${cat.spent.toStringAsFixed(0)} / ${cat.cap.toStringAsFixed(0)}',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => ref
                  .read(budgetControllerProvider.notifier)
                  .addPayment(50, summary.categories.first.name),
              icon: const Icon(Icons.add),
              label: const Text('Add payment (demo optimistic)'),
            ),
          ],
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
