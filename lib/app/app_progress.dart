import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class AppProgress extends ChangeNotifier {
  AppProgress._(this._preferences);

  static const _xpKey = 'progress.xp';
  static const _matchesKey = 'progress.matches';
  static const _winsKey = 'progress.wins';
  static const _bestStreakKey = 'progress.bestStreak';
  static const _currentStreakKey = 'progress.currentStreak';
  static const _shotsKey = 'progress.shots';
  static const _potsKey = 'progress.pots';

  final SharedPreferences _preferences;
  int _xp = 0;
  int _matches = 0;
  int _wins = 0;
  int _bestStreak = 0;
  int _currentStreak = 0;
  int _shots = 0;
  int _pots = 0;

  static AppProgress load(SharedPreferences preferences) {
    return AppProgress._(preferences)
      .._xp = preferences.getInt(_xpKey) ?? 0
      .._matches = preferences.getInt(_matchesKey) ?? 0
      .._wins = preferences.getInt(_winsKey) ?? 0
      .._bestStreak = preferences.getInt(_bestStreakKey) ?? 0
      .._currentStreak = preferences.getInt(_currentStreakKey) ?? 0
      .._shots = preferences.getInt(_shotsKey) ?? 0
      .._pots = preferences.getInt(_potsKey) ?? 0;
  }

  int get xp => _xp;
  int get matches => _matches;
  int get wins => _wins;
  int get bestStreak => _bestStreak;
  int get shots => _shots;
  int get pots => _pots;
  int get level => 1 + (_xp ~/ 500);
  int get xpIntoLevel => _xp % 500;
  double get accuracy => _shots == 0 ? 0 : _pots / _shots;

  void recordShot({required int pocketedBalls}) {
    _shots++;
    _pots += pocketedBalls.clamp(0, 15);
    unawaited(_preferences.setInt(_shotsKey, _shots));
    unawaited(_preferences.setInt(_potsKey, _pots));
    notifyListeners();
  }

  void recordMatch({required bool won}) {
    _matches++;
    _xp += won ? 150 : 60;
    if (won) {
      _wins++;
      _currentStreak++;
      if (_currentStreak > _bestStreak) _bestStreak = _currentStreak;
    } else {
      _currentStreak = 0;
    }
    unawaited(_persistMatch());
    notifyListeners();
  }

  Future<void> clear() async {
    _xp = 0;
    _matches = 0;
    _wins = 0;
    _bestStreak = 0;
    _currentStreak = 0;
    _shots = 0;
    _pots = 0;
    for (final key in <String>[
      _xpKey,
      _matchesKey,
      _winsKey,
      _bestStreakKey,
      _currentStreakKey,
      _shotsKey,
      _potsKey,
    ]) {
      await _preferences.remove(key);
    }
    notifyListeners();
  }

  Future<void> _persistMatch() async {
    await Future.wait(<Future<bool>>[
      _preferences.setInt(_xpKey, _xp),
      _preferences.setInt(_matchesKey, _matches),
      _preferences.setInt(_winsKey, _wins),
      _preferences.setInt(_bestStreakKey, _bestStreak),
      _preferences.setInt(_currentStreakKey, _currentStreak),
    ]);
  }
}
