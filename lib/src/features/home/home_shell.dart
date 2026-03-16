import 'package:flutter/material.dart';

import '../../core/theme/theme_controller.dart';
import '../dashboard/presentation/dashboard_screen.dart';
import '../shopping/presentation/shopping_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.themeController});

  final ThemeController themeController;

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
            onPressed: widget.themeController.next,
            icon: Icon(switch (widget.themeController.mode) {
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
