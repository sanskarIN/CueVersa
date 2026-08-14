import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_progress.dart';
import 'app/app_settings.dart';
import 'app/cue_verse_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final settings = await AppSettings.load(preferences);
  final progress = AppProgress.load(preferences);
  runApp(CueVerseApp(settings: settings, progress: progress));
}
