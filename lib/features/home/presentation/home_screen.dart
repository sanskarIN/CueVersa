import 'package:flutter/material.dart';

import '../../../app/app_progress.dart';
import '../../../app/app_settings.dart';
import '../../../core/widgets/brand_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../more/presentation/content_screens.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../support/presentation/support_screen.dart';
import 'mode_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.settings, required this.progress, super.key});

  final AppSettings settings;
  final AppProgress progress;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              sliver: SliverToBoxAdapter(child: _Hero(progress: progress)),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverGrid.extent(
                maxCrossAxisExtent: 230,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.45,
                children: <Widget>[
                  _HomeAction(
                    icon: Icons.play_arrow_rounded,
                    title: localizations.play,
                    subtitle: localizations.selectMode,
                    prominent: true,
                    onTap: () => _open(
                      context,
                      ModeSelectionScreen(
                        settings: settings,
                        progress: progress,
                      ),
                    ),
                  ),
                  _HomeAction(
                    icon: Icons.flag_rounded,
                    title: localizations.challenges,
                    subtitle: localizations.dailyChallenge,
                    onTap: () => _open(context, const ChallengesScreen()),
                  ),
                  _HomeAction(
                    icon: Icons.workspace_premium_rounded,
                    title: localizations.achievements,
                    subtitle: localizations.weeklyMissions,
                    onTap: () => _open(context, const AchievementsScreen()),
                  ),
                  _HomeAction(
                    icon: Icons.query_stats_rounded,
                    title: localizations.statistics,
                    subtitle: localizations.level(progress.level),
                    onTap: () =>
                        _open(context, StatisticsScreen(progress: progress)),
                  ),
                  _HomeAction(
                    icon: Icons.tune_rounded,
                    title: localizations.settings,
                    subtitle: localizations.settingsAccessibility,
                    onTap: () => _open(
                      context,
                      SettingsScreen(settings: settings, progress: progress),
                    ),
                  ),
                  _HomeAction(
                    icon: Icons.info_outline_rounded,
                    title: localizations.about,
                    subtitle: localizations.openSource,
                    onTap: () => _open(context, const AboutScreen()),
                  ),
                  _HomeAction(
                    icon: Icons.school_outlined,
                    title: localizations.tutorial,
                    subtitle: localizations.aimHint,
                    onTap: () => _open(context, const TutorialScreen()),
                  ),
                  _HomeAction(
                    icon: Icons.menu_book_rounded,
                    title: localizations.rulesGuide,
                    subtitle: localizations.eightBall,
                    onTap: () => _open(context, const RulesGuideScreen()),
                  ),
                  _HomeAction(
                    icon: Icons.auto_awesome_rounded,
                    title: localizations.cosmetics,
                    subtitle: localizations.freeAndFair,
                    onTap: () => _open(context, const CosmeticsScreen()),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    const BmcSupportCard(),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _open(context, const SupportScreen()),
                      icon: const Icon(Icons.favorite_outline_rounded),
                      label: Text(localizations.support),
                    ),
                    const SizedBox(height: 18),
                    const CreatorWatermark(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (context) => screen));
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.progress});

  final AppProgress progress;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[colors.primaryContainer, colors.surfaceContainer],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: <Widget>[
            const CueVerseMark(size: 82),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    localizations.appName,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(localizations.tagline),
                  const SizedBox(height: 14),
                  Text(
                    localizations.level(progress.level),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 5),
                  Semantics(
                    label: localizations.xpProgress(progress.xpIntoLevel, 500),
                    child: LinearProgressIndicator(
                      value: progress.xpIntoLevel / 500,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.prominent = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: prominent ? colors.primaryContainer : null,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: prominent ? colors.primary : null),
              const Spacer(),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
