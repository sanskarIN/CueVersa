import 'package:flutter/material.dart';

abstract final class CueTheme {
  static const _deepNavy = Color(0xFF071B2D);
  static const _felt = Color(0xFF007A65);
  static const _mint = Color(0xFF67E8C4);
  static const _gold = Color(0xFFF7C948);

  static ThemeData light({required bool highContrast}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _felt,
      brightness: Brightness.light,
      primary: highContrast ? const Color(0xFF005143) : _felt,
      secondary: const Color(0xFF9B6200),
      surface: highContrast ? Colors.white : const Color(0xFFF4F8F7),
    );
    return _base(scheme, highContrast: highContrast);
  }

  static ThemeData dark({required bool highContrast}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _mint,
      brightness: Brightness.dark,
      primary: highContrast ? const Color(0xFF9FFFE4) : _mint,
      secondary: _gold,
      surface: highContrast ? Colors.black : _deepNavy,
    );
    return _base(scheme, highContrast: highContrast);
  }

  static ThemeData _base(ColorScheme scheme, {required bool highContrast}) {
    const radius = BorderRadius.all(Radius.circular(20));
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.standard,
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontWeight: FontWeight.w900,
          letterSpacing: -.8,
        ),
        headlineMedium: TextStyle(fontWeight: FontWeight.w800),
        titleLarge: TextStyle(fontWeight: FontWeight.w800),
        titleMedium: TextStyle(fontWeight: FontWeight.w700),
        labelLarge: TextStyle(fontWeight: FontWeight.w700, letterSpacing: .2),
      ),
      cardTheme: CardThemeData(
        elevation: highContrast ? 0 : 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: highContrast ? scheme.outline : scheme.outlineVariant,
            width: highContrast ? 2 : 1,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: const RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: radius),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        },
      ),
    );
  }
}
