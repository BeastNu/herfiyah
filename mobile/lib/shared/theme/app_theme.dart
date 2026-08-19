import 'package:flutter/material.dart';

/// Centralised theme accessor.
///
/// Call [AppTheme.of(context)] from any widget to read the current
/// [ThemeData] without hard-coding colour values in individual widgets.
/// Export this file and use it as the single source of truth for brand tokens.
class AppTheme {
  AppTheme._();

  // --- Brand colours --------------------------------------------------------
  static const Color gold = Color(0xFFC9A84C);
  static const Color darkGold = Color(0xFFA68A2A);
  static const Color lightGold = Color(0xFFE8D48B);

  static const Color warmBg = Color(0xFFFAF7F0);
  static const Color darkBg = Color(0xFF121212);
  static const Color surfaceBg = Color(0xFF1E1E1E);

  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF6B6B6B);

  /// Convenience — shorthand for Theme.of(context).
  static ThemeData of(BuildContext context) => Theme.of(context);
}