import 'package:flutter/material.dart';

import '../shopping_screen.dart';

class ShoppingTile extends StatelessWidget {
  const ShoppingTile(this.item, {super.key});

  final ShoppingItem item;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: Checkbox(value: false, onChanged: (_) {}),
        title: Text(item.name),
        subtitle: Row(
          children: [
            _Chip(
              label: item.qty,
              color: cs.primaryContainer,
              textColor: cs.onPrimaryContainer,
            ),
            const SizedBox(width: 6),
            _Chip(
              label: item.category,
              color: cs.surfaceVariant,
              textColor: cs.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            _Chip(
              label: item.expiry,
              color: cs.tertiaryContainer,
              textColor: cs.onTertiaryContainer,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.status, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Switch(
              value: item.autoAdd,
              onChanged: (_) {},
              activeColor: cs.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: TextStyle(color: textColor, fontSize: 12)),
    );
  }
}
