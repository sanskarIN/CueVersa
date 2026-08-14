import 'package:cue_versa/app/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('defaults are accessible and local-first', () async {
    final preferences = await SharedPreferences.getInstance();
    final settings = await AppSettings.load(preferences);

    expect(settings.theme, AppThemePreference.system);
    expect(settings.locale, const Locale('en'));
    expect(settings.haptics, isTrue);
    expect(settings.reducedMotion, isFalse);
    expect(settings.developerUnlocked, isFalse);
  });

  test('settings persist and invalid sensitivity is bounded', () async {
    final preferences = await SharedPreferences.getInstance();
    final settings = await AppSettings.load(preferences);
    settings
      ..setTheme(AppThemePreference.dark)
      ..setLocale(const Locale('hi'))
      ..setReducedMotion(true)
      ..setAimSensitivity(9)
      ..unlockDeveloperOptions();
    await Future<void>.delayed(Duration.zero);

    final restored = await AppSettings.load(preferences);
    expect(restored.theme, AppThemePreference.dark);
    expect(restored.locale, const Locale('hi'));
    expect(restored.reducedMotion, isTrue);
    expect(restored.aimSensitivity, 2);
    expect(restored.developerUnlocked, isTrue);
  });

  test('restore defaults removes all persisted settings', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'settings.theme': 'dark',
      'settings.locale': 'hi',
      'settings.highContrast': true,
    });
    final preferences = await SharedPreferences.getInstance();
    final settings = await AppSettings.load(preferences);

    await settings.restoreDefaults();

    expect(settings.theme, AppThemePreference.system);
    expect(settings.locale, const Locale('en'));
    expect(settings.highContrast, isFalse);
    expect(
      preferences.getKeys().where((key) => key.startsWith('settings.')),
      isEmpty,
    );
  });
}
