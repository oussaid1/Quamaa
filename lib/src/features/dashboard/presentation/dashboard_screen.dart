import 'package:flutter/material.dart';

import 'widgets/dashboard_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        QuamaaCard(
          child: Row(
            children: [
              Ring(
                color: cs.primary,
                value: 0.62,
                label: 'الرصيد المتبقي',
                caption: '2,450 / 3,000',
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
                      value: 0.62,
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
          trailing: TextButton(onPressed: () {}, child: const Text('View all')),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              AlertChip(label: 'انتهاء صلاحية عناصر المطبخ', tone: Tone.warn),
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
                  children: const [
                    BarRow(
                      label: 'أطعمة',
                      value: 0.8,
                      caption: '1,200 / 1,500',
                    ),
                    BarRow(label: 'فواتير', value: 0.7, caption: '400 / 500'),
                    BarRow(label: 'ترفيه', value: 0.3, caption: '150 / 500'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuamaaCard(
                title: 'By store',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    BarRow(label: 'كارفور', value: 0.6, caption: '300 / 500'),
                    BarRow(
                      label: 'بقالة الحي',
                      value: 0.5,
                      caption: '120 / 200',
                    ),
                    BarRow(
                      label: 'Unassigned',
                      value: 0.2,
                      caption: '40 / 200',
                    ),
                  ],
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
              ActionButton(icon: Icons.add_shopping_cart, label: 'Add item'),
              ActionButton(icon: Icons.attach_money, label: 'Log income'),
              ActionButton(icon: Icons.payments_outlined, label: 'Pay store'),
              ActionButton(
                icon: Icons.inventory_2_outlined,
                label: 'Toggle Auto-Add',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
