import 'package:flutter/material.dart';

import '../core/theme/cue_theme.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/home/presentation/splash_screen.dart';
import '../l10n/app_localizations.dart';
import 'app_progress.dart';
import 'app_settings.dart';

class CueVerseApp extends StatelessWidget {
  const CueVerseApp({
    required this.settings,
    required this.progress,
    super.key,
  });

  final AppSettings settings;
  final AppProgress progress;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appName,
          debugShowCheckedModeBanner: false,
          locale: settings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          themeMode: settings.themeMode,
          theme: CueTheme.light(highContrast: settings.highContrast),
          darkTheme: CueTheme.dark(highContrast: settings.highContrast),
          builder: (context, child) {
            final media = MediaQuery.of(context);
            return MediaQuery(
              data: media.copyWith(
                disableAnimations:
                    settings.reducedMotion || media.disableAnimations,
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: SplashScreen(
            destination: HomeScreen(settings: settings, progress: progress),
          ),
        );
      },
    );
  }
}
