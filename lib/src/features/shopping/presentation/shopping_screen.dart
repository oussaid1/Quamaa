import 'package:flutter/material.dart';

import '../widgets/shopping_tile.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = ['الكل', 'منخفض', 'نفد', 'منتهي قريبًا', 'المتجر'];
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
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              const _StoreHeader('كارفور'),
              ..._demoItems.take(3).map((item) => ShoppingTile(item)),
              const SizedBox(height: 12),
              const _StoreHeader('بقالة الحي'),
              ..._demoItems.skip(3).map((item) => ShoppingTile(item)),
            ],
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

class ShoppingItem {
  const ShoppingItem({
    required this.name,
    required this.qty,
    required this.category,
    required this.expiry,
    required this.status,
    required this.autoAdd,
  });

  final String name;
  final String qty;
  final String category;
  final String expiry;
  final String status;
  final bool autoAdd;
}

const _demoItems = [
  ShoppingItem(
    name: 'حليب 2L',
    qty: 'x2',
    category: 'أطعمة',
    expiry: 'ينتهي خلال 2 يوم',
    status: 'منخفض',
    autoAdd: true,
  ),
  ShoppingItem(
    name: 'بيض 12',
    qty: 'x1',
    category: 'أطعمة',
    expiry: 'ينتهي خلال 4 أيام',
    status: 'متوفر',
    autoAdd: true,
  ),
  ShoppingItem(
    name: 'دجاج كامل',
    qty: 'x1',
    category: 'أطعمة',
    expiry: 'ينتهي خلال 1 يوم',
    status: 'منتهي قريبًا',
    autoAdd: false,
  ),
  ShoppingItem(
    name: 'منظف أرضيات',
    qty: 'x1',
    category: 'تنظيف',
    expiry: '—',
    status: 'متوفر',
    autoAdd: false,
  ),
  ShoppingItem(
    name: 'مياه 6x1.5L',
    qty: 'x1',
    category: 'مشروبات',
    expiry: '—',
    status: 'نفد',
    autoAdd: true,
  ),
];
