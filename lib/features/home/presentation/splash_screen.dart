import 'package:flutter/material.dart';

import '../../../core/widgets/brand_widgets.dart';
import '../../../l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({required this.destination, super.key});

  final Widget destination;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement<void, void>(
        PageRouteBuilder<void>(
          transitionDuration: Duration.zero,
          pageBuilder: (context, animation, secondaryAnimation) {
            return widget.destination;
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const CueVerseMark(size: 124),
                const SizedBox(height: 22),
                Text(
                  localizations.appName,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 6),
                Text(localizations.tagline, textAlign: TextAlign.center),
                const SizedBox(height: 28),
                const CreatorWatermark(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
