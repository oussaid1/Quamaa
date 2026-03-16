import 'package:flutter/material.dart';

void main() {
  runApp(const QuamaaApp());
}

class QuamaaApp extends StatefulWidget {
  const QuamaaApp({super.key});

  @override
  State<QuamaaApp> createState() => _QuamaaAppState();
}

class _QuamaaAppState extends State<QuamaaApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleThemeMode() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF0EA5E9);
    return MaterialApp(
      title: 'Quamaa',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
      ),
      home: HomeShell(
        themeMode: _themeMode,
        onToggleThemeMode: _toggleThemeMode,
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.themeMode,
    required this.onToggleThemeMode,
  });

  final ThemeMode themeMode;
  final VoidCallback onToggleThemeMode;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final _screens = const [DashboardScreen(), ShoppingListScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quamaa'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: widget.onToggleThemeMode,
            icon: Icon(switch (widget.themeMode) {
              ThemeMode.light => Icons.dark_mode_outlined,
              ThemeMode.dark => Icons.brightness_7_outlined,
              _ => Icons.brightness_auto_outlined,
            }),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (value) => setState(() => _currentIndex = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shopping',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Card(
          child: Row(
            children: [
              _Ring(
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
        _Card(
          title: 'Alerts',
          trailing: TextButton(onPressed: () {}, child: const Text('View all')),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _AlertChip(label: 'انتهاء صلاحية عناصر المطبخ', tone: _Tone.warn),
              _AlertChip(label: 'تجاوز الحصة للمتجر', tone: _Tone.error),
              _AlertChip(label: 'قرب نفاد الميزانية', tone: _Tone.warn),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _Card(
                title: 'By category',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _BarRow(
                      label: 'أطعمة',
                      value: 0.8,
                      caption: '1,200 / 1,500',
                    ),
                    _BarRow(label: 'فواتير', value: 0.7, caption: '400 / 500'),
                    _BarRow(label: 'ترفيه', value: 0.3, caption: '150 / 500'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Card(
                title: 'By store',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _BarRow(label: 'كارفور', value: 0.6, caption: '300 / 500'),
                    _BarRow(
                      label: 'بقالة الحي',
                      value: 0.5,
                      caption: '120 / 200',
                    ),
                    _BarRow(
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
        _Card(
          title: 'Quick actions',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _ActionButton(icon: Icons.add_shopping_cart, label: 'Add item'),
              _ActionButton(icon: Icons.attach_money, label: 'Log income'),
              _ActionButton(icon: Icons.payments_outlined, label: 'Pay store'),
              _ActionButton(
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
              ..._demoItems.take(3).map((item) => _ShoppingTile(item)),
              const SizedBox(height: 12),
              const _StoreHeader('بقالة الحي'),
              ..._demoItems.skip(3).map((item) => _ShoppingTile(item)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({this.title, this.trailing, required this.child});

  final String? title;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null || trailing != null) ...[
              Row(
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  const Spacer(),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({
    required this.color,
    required this.value,
    required this.label,
    required this.caption,
  });

  final Color color;
  final double value;
  final String label;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 96,
          width: 96,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 8,
                color: color,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              Center(
                child: Text(
                  '${(value * 100).round()}%',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(caption, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

enum _Tone { neutral, warn, error }

class _AlertChip extends StatelessWidget {
  const _AlertChip({required this.label, this.tone = _Tone.neutral});

  final String label;
  final _Tone tone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (bg, fg) = switch (tone) {
      _Tone.warn => (cs.secondaryContainer, cs.onSecondaryContainer),
      _Tone.error => (cs.errorContainer, cs.onErrorContainer),
      _ => (cs.surfaceVariant, cs.onSurfaceVariant),
    };
    return Chip(
      label: Text(label),
      backgroundColor: bg,
      side: BorderSide(color: cs.outlineVariant),
      labelStyle: TextStyle(color: fg),
    );
  }
}

class _BarRow extends StatelessWidget {
  const _BarRow({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final double value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text(caption, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: cs.surfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
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

class _ShoppingTile extends StatelessWidget {
  const _ShoppingTile(this.item);

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
