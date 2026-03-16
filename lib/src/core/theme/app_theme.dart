import 'package:flutter/material.dart';

class AppTheme {
  static const _seed = Color(0xFF0EA5E9);
  static const _font = 'Roboto';

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: _font,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    fontFamily: _font,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
  );
}
