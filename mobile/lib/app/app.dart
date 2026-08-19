import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/router.dart';

/// The root widget for the Herfiyah (حِرفيّة) beauty services marketplace.
///
/// Sets up MaterialApp with GoRouter navigation and the app's gold/dark theme.
/// Riverpod's ProviderScope is provided by main.dart; this widget receives the
/// [Ref] implicitly through its ConsumerStatefulWidget ancestry.
class HerfiyahApp extends ConsumerWidget {
  const HerfiyahApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Herfiyah - حرفية',
      debugShowCheckedModeBanner: false,

      // --- Theme ----------------------------------------------------------
      // Gold / dark palette inspired by traditional craftsmanship (حِرفيّة).
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,

      // --- Routing --------------------------------------------------------
      routerConfig: appRouter,
    );
  }

  /// Light theme – warm ivory base with gold accents.
  ThemeData _buildLightTheme() {
    const Color gold = Color(0xFFC9A84C);       // primary gold
    const Color darkGold = Color(0xFFA68A2A);    // deeper gold for emphasis
    const Color warmBg = Color(0xFFFAF7F0);      // warm off-white

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: gold,
      scaffoldBackgroundColor: warmBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF2D2D2D)),
        titleTextStyle: TextStyle(
          color: Color(0xFF2D2D2D),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0DCC8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gold, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  /// Dark theme – deep charcoal base with gold highlights.
  ThemeData _buildDarkTheme() {
    const Color gold = Color(0xFFD4AF37);       // warm gold on dark
    const Color darkBg = Color(0xFF121212);      // near-black background
    const Color surfaceBg = Color(0xFF1E1E1E);   // card / surface

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: gold,
      scaffoldBackgroundColor: darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFE0E0E0)),
        titleTextStyle: TextStyle(
          color: Color(0xFFE0E0E0),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: const CardThemeData(
        color: surfaceBg,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: const Color(0xFF1A1A1A),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gold, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}