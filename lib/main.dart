import 'package:flutter/material.dart';

void main() {
  runApp(const QuamaaApp());
}

class QuamaaApp extends StatelessWidget {
  const QuamaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quamaa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0EA5E9)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const _LandingScreen(),
    );
  }
}

class _LandingScreen extends StatelessWidget {
  const _LandingScreen();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quamaa'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Household Spend & Pantry OS',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Unified dashboard for budget, shopping, inventory, and store quotas. '
              'Start building the Quamaa experience here.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _FeatureChip(label: 'Dashboard'),
                _FeatureChip(label: 'Shopping List'),
                _FeatureChip(label: 'Kitchen Inventory'),
                _FeatureChip(label: 'Budget'),
                _FeatureChip(label: 'Stores & Credit'),
                _FeatureChip(label: 'Statistics'),
              ],
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      side: BorderSide(color: Theme.of(context).colorScheme.outline),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
    );
  }
}
