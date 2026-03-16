import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/stats_providers.dart';
import 'widgets/dashboard_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsOverviewProvider);
    final cs = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(statsOverviewProvider.future),
      child: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorRetry(
          message: '$err',
          onRetry: () => ref.refresh(statsOverviewProvider),
        ),
        data: (stats) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            QuamaaCard(
              child: Row(
                children: [
                  Ring(
                    color: cs.primary,
                    value: stats.remainingRatio,
                    label: 'الرصيد المتبقي',
                    caption: stats.remainingCaption,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly budget',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: stats.remainingRatio,
                          backgroundColor: cs.surfaceVariant,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Burn rate trending safe',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            QuamaaCard(
              title: 'Alerts',
              trailing: TextButton(
                onPressed: () {},
                child: const Text('View all'),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  AlertChip(
                    label: 'انتهاء صلاحية عناصر المطبخ',
                    tone: Tone.warn,
                  ),
                  AlertChip(label: 'تجاوز الحصة للمتجر', tone: Tone.error),
                  AlertChip(label: 'قرب نفاد الميزانية', tone: Tone.warn),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: QuamaaCard(
                    title: 'By category',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: stats.categories
                          .map(
                            (cat) => BarRow(
                              label: cat.label,
                              value: cat.ratio,
                              caption:
                                  '${cat.spent.toStringAsFixed(0)} / ${cat.cap.toStringAsFixed(0)}',
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QuamaaCard(
                    title: 'By store',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: stats.stores
                          .map(
                            (store) => BarRow(
                              label: store.label,
                              value: store.ratio,
                              caption:
                                  '${store.spent.toStringAsFixed(0)} / ${store.cap.toStringAsFixed(0)}',
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const QuamaaCard(
              title: 'Quick actions',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ActionButton(
                    icon: Icons.add_shopping_cart,
                    label: 'Add item',
                  ),
                  ActionButton(icon: Icons.attach_money, label: 'Log income'),
                  ActionButton(
                    icon: Icons.payments_outlined,
                    label: 'Pay store',
                  ),
                  ActionButton(
                    icon: Icons.inventory_2_outlined,
                    label: 'Toggle Auto-Add',
                  ),
                ],
              ),
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
