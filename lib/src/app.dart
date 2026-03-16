import 'package:flutter/material.dart';

import 'core/auth/auth_gate.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

class QuamaaApp extends StatefulWidget {
  const QuamaaApp({super.key});

  @override
  State<QuamaaApp> createState() => _QuamaaAppState();
}

class _QuamaaAppState extends State<QuamaaApp> {
  final ThemeController _themeController = ThemeController();

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (_, __) {
        return MaterialApp(
          title: 'Quamaa',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: _themeController.mode,
          home: AuthGate(themeController: _themeController),
        );
      },
    );
  }
}
