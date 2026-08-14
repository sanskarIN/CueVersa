import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemePreference { system, light, dark }

final class AppSettings extends ChangeNotifier {
  AppSettings._(this._preferences);

  static const _themeKey = 'settings.theme';
  static const _localeKey = 'settings.locale';
  static const _highContrastKey = 'settings.highContrast';
  static const _reducedMotionKey = 'settings.reducedMotion';
  static const _leftHandedKey = 'settings.leftHanded';
  static const _hapticsKey = 'settings.haptics';
  static const _soundEffectsKey = 'settings.soundEffects';
  static const _musicKey = 'settings.music';
  static const _batterySaverKey = 'settings.batterySaver';
  static const _aimSensitivityKey = 'settings.aimSensitivity';
  static const _developerUnlockedKey = 'settings.developerUnlocked';

  final SharedPreferences _preferences;

  AppThemePreference _theme = AppThemePreference.system;
  Locale _locale = const Locale('en');
  bool _highContrast = false;
  bool _reducedMotion = false;
  bool _leftHanded = false;
  bool _haptics = true;
  bool _soundEffects = true;
  bool _music = true;
  bool _batterySaver = false;
  double _aimSensitivity = 1;
  bool _developerUnlocked = false;

  static Future<AppSettings> load(SharedPreferences preferences) async {
    final settings = AppSettings._(preferences);
    settings._theme = AppThemePreference.values.firstWhere(
      (value) => value.name == preferences.getString(_themeKey),
      orElse: () => AppThemePreference.system,
    );
    final localeCode = preferences.getString(_localeKey) ?? 'en';
    settings._locale = Locale(localeCode == 'hi' ? 'hi' : 'en');
    settings._highContrast = preferences.getBool(_highContrastKey) ?? false;
    settings._reducedMotion = preferences.getBool(_reducedMotionKey) ?? false;
    settings._leftHanded = preferences.getBool(_leftHandedKey) ?? false;
    settings._haptics = preferences.getBool(_hapticsKey) ?? true;
    settings._soundEffects = preferences.getBool(_soundEffectsKey) ?? true;
    settings._music = preferences.getBool(_musicKey) ?? true;
    settings._batterySaver = preferences.getBool(_batterySaverKey) ?? false;
    settings._aimSensitivity = (preferences.getDouble(_aimSensitivityKey) ?? 1)
        .clamp(.5, 2)
        .toDouble();
    settings._developerUnlocked =
        preferences.getBool(_developerUnlockedKey) ?? false;
    return settings;
  }

  AppThemePreference get theme => _theme;
  Locale get locale => _locale;
  bool get highContrast => _highContrast;
  bool get reducedMotion => _reducedMotion;
  bool get leftHanded => _leftHanded;
  bool get haptics => _haptics;
  bool get soundEffects => _soundEffects;
  bool get music => _music;
  bool get batterySaver => _batterySaver;
  double get aimSensitivity => _aimSensitivity;
  bool get developerUnlocked => _developerUnlocked;

  ThemeMode get themeMode => switch (_theme) {
    AppThemePreference.system => ThemeMode.system,
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
  };

  void setTheme(AppThemePreference value) {
    if (_theme == value) return;
    _theme = value;
    _changed(_themeKey, value.name);
  }

  void setLocale(Locale value) {
    final supported = value.languageCode == 'hi'
        ? const Locale('hi')
        : const Locale('en');
    if (_locale == supported) return;
    _locale = supported;
    _changed(_localeKey, supported.languageCode);
  }

  void setHighContrast(bool value) => _setBool(
    value: value,
    current: _highContrast,
    key: _highContrastKey,
    assign: (next) => _highContrast = next,
  );

  void setReducedMotion(bool value) => _setBool(
    value: value,
    current: _reducedMotion,
    key: _reducedMotionKey,
    assign: (next) => _reducedMotion = next,
  );

  void setLeftHanded(bool value) => _setBool(
    value: value,
    current: _leftHanded,
    key: _leftHandedKey,
    assign: (next) => _leftHanded = next,
  );

  void setHaptics(bool value) => _setBool(
    value: value,
    current: _haptics,
    key: _hapticsKey,
    assign: (next) => _haptics = next,
  );

  void setSoundEffects(bool value) => _setBool(
    value: value,
    current: _soundEffects,
    key: _soundEffectsKey,
    assign: (next) => _soundEffects = next,
  );

  void setMusic(bool value) => _setBool(
    value: value,
    current: _music,
    key: _musicKey,
    assign: (next) => _music = next,
  );

  void setBatterySaver(bool value) => _setBool(
    value: value,
    current: _batterySaver,
    key: _batterySaverKey,
    assign: (next) => _batterySaver = next,
  );

  void setAimSensitivity(double value) {
    final next = value.clamp(.5, 2).toDouble();
    if (_aimSensitivity == next) return;
    _aimSensitivity = next;
    notifyListeners();
    unawaited(_preferences.setDouble(_aimSensitivityKey, next));
  }

  void unlockDeveloperOptions() {
    if (_developerUnlocked) return;
    _developerUnlocked = true;
    _changed(_developerUnlockedKey, true);
  }

  Future<void> restoreDefaults() async {
    _theme = AppThemePreference.system;
    _locale = const Locale('en');
    _highContrast = false;
    _reducedMotion = false;
    _leftHanded = false;
    _haptics = true;
    _soundEffects = true;
    _music = true;
    _batterySaver = false;
    _aimSensitivity = 1;
    _developerUnlocked = false;
    for (final key in _settingKeys) {
      await _preferences.remove(key);
    }
    notifyListeners();
  }

  static const _settingKeys = <String>{
    _themeKey,
    _localeKey,
    _highContrastKey,
    _reducedMotionKey,
    _leftHandedKey,
    _hapticsKey,
    _soundEffectsKey,
    _musicKey,
    _batterySaverKey,
    _aimSensitivityKey,
    _developerUnlockedKey,
  };

  void _setBool({
    required bool value,
    required bool current,
    required String key,
    required void Function(bool) assign,
  }) {
    if (current == value) return;
    assign(value);
    _changed(key, value);
  }

  void _changed(String key, Object value) {
    notifyListeners();
    if (value is bool) {
      unawaited(_preferences.setBool(key, value));
    } else if (value is String) {
      unawaited(_preferences.setString(key, value));
    }
  }
}
