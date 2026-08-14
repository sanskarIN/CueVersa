import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/app_progress.dart';
import '../../../core/constants/project_links.dart';
import '../../../core/utils/external_links.dart';
import '../../../core/widgets/brand_widgets.dart';
import '../../../l10n/app_localizations.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({required this.progress, super.key});

  final AppProgress progress;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final percent = NumberFormat.percentPattern(
      localizations.localeName,
    ).format(progress.accuracy);
    return Scaffold(
      appBar: AppBar(title: Text(localizations.statistics)),
      body: ListenableBuilder(
        listenable: progress,
        builder: (context, _) => GridView.extent(
          padding: const EdgeInsets.all(20),
          maxCrossAxisExtent: 220,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: <Widget>[
            _StatCard(localizations.matchesPlayed, '${progress.matches}'),
            _StatCard(localizations.wins, '${progress.wins}'),
            _StatCard(localizations.bestStreak, '${progress.bestStreak}'),
            _StatCard(localizations.accuracy, percent),
            _StatCard(localizations.level(progress.level), '${progress.xp} XP'),
          ],
        ),
      ),
    );
  }
}

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return _SimpleScaffold(
      title: localizations.challenges,
      children: <Widget>[
        _ProgressTile(
          icon: Icons.bolt_rounded,
          title: localizations.dailyChallenge,
          subtitle: localizations.practice,
          value: .35,
        ),
        _ProgressTile(
          icon: Icons.calendar_view_week_rounded,
          title: localizations.weeklyMissions,
          subtitle: localizations.eightBall,
          value: .2,
        ),
      ],
    );
  }
}

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return _SimpleScaffold(
      title: localizations.achievements,
      children: <Widget>[
        _AchievementTile(
          icon: Icons.sports_score_rounded,
          title: localizations.wins,
          status: localizations.locked,
        ),
        _AchievementTile(
          icon: Icons.track_changes_rounded,
          title: localizations.accuracy,
          status: localizations.locked,
        ),
        _AchievementTile(
          icon: Icons.local_fire_department_rounded,
          title: localizations.bestStreak,
          status: localizations.locked,
        ),
      ],
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localizations.about)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          const Center(child: CueVerseMark(size: 108)),
          const SizedBox(height: 16),
          Text(
            localizations.appName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(localizations.tagline, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            localizations.versionLabel('1.0.0+1'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.code_rounded),
            title: Text(localizations.openSource),
            subtitle: Text(localizations.repository),
            trailing: const Icon(Icons.open_in_new_rounded),
            onTap: () => openExternalLink(context, ProjectLinks.repository),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded),
            title: Text(localizations.creatorProfile),
            subtitle: const Text('github.com/sanskarIN'),
            trailing: const Icon(Icons.open_in_new_rounded),
            onTap: () => openExternalLink(context, ProjectLinks.creator),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(localizations.privacyPolicy),
            subtitle: Text(localizations.offlineOnly),
          ),
          ListTile(
            leading: const Icon(Icons.gavel_rounded),
            title: Text(localizations.terms),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_rounded),
            title: Text(localizations.thirdPartyNotices),
          ),
          const SizedBox(height: 18),
          const BmcSupportCard(),
          const SizedBox(height: 24),
          const CreatorWatermark(),
        ],
      ),
    );
  }
}

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return _SimpleScaffold(
      title: localizations.tutorial,
      children: <Widget>[
        _NumberedTile(number: 1, title: localizations.aimHint),
        _NumberedTile(number: 2, title: localizations.power),
        _NumberedTile(number: 3, title: localizations.spin),
        _NumberedTile(number: 4, title: localizations.shoot),
      ],
    );
  }
}

class RulesGuideScreen extends StatelessWidget {
  const RulesGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return _SimpleScaffold(
      title: localizations.rulesGuide,
      children: <Widget>[
        _AchievementTile(
          icon: Icons.filter_8_rounded,
          title: localizations.eightBall,
          status: localizations.wpaInspired,
        ),
        _AchievementTile(
          icon: Icons.filter_9_rounded,
          title: localizations.nineBall,
          status: localizations.casualRules,
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(localizations.notOfficialRules),
        ),
      ],
    );
  }
}

class CosmeticsScreen extends StatelessWidget {
  const CosmeticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return _SimpleScaffold(
      title: localizations.cosmetics,
      children: <Widget>[
        _AchievementTile(
          icon: Icons.color_lens_outlined,
          title: localizations.theme,
          status: localizations.equipped,
        ),
        _AchievementTile(
          icon: Icons.auto_awesome_rounded,
          title: localizations.cosmetics,
          status: localizations.locked,
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(localizations.freeAndFair),
        ),
      ],
    );
  }
}

class DeveloperOptionsScreen extends StatefulWidget {
  const DeveloperOptionsScreen({super.key});

  @override
  State<DeveloperOptionsScreen> createState() => _DeveloperOptionsScreenState();
}

class _DeveloperOptionsScreenState extends State<DeveloperOptionsScreen> {
  final _seedController = TextEditingController(text: '1');
  bool _fpsOverlay = false;
  bool _stateInspector = false;
  bool _featureFlags = false;
  bool _localizationInspector = false;
  bool _networkDiagnostics = false;

  @override
  void dispose() {
    _seedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsDeveloper)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(localizations.diagnosticsSafe),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile.adaptive(
            value: _fpsOverlay,
            title: Text(localizations.fpsOverlay),
            onChanged: (value) => setState(() => _fpsOverlay = value),
          ),
          SwitchListTile.adaptive(
            value: _stateInspector,
            title: Text(localizations.stateInspector),
            onChanged: (value) => setState(() => _stateInspector = value),
          ),
          SwitchListTile.adaptive(
            value: _featureFlags,
            title: Text(localizations.featureFlags),
            onChanged: (value) => setState(() => _featureFlags = value),
          ),
          SwitchListTile.adaptive(
            value: _localizationInspector,
            title: Text(localizations.localizationInspector),
            onChanged: (value) =>
                setState(() => _localizationInspector = value),
          ),
          SwitchListTile.adaptive(
            value: _networkDiagnostics,
            title: Text(localizations.networkDiagnostics),
            onChanged: (value) => setState(() => _networkDiagnostics = value),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _seedController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: localizations.deterministicSeed,
              helperText: localizations.simulationRate,
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.restart_alt_rounded),
            label: Text(localizations.developerReset),
          ),
        ],
      ),
    );
  }

  void _reset() {
    setState(() {
      _seedController.text = '1';
      _fpsOverlay = false;
      _stateInspector = false;
      _featureFlags = false;
      _localizationInspector = false;
      _networkDiagnostics = false;
    });
  }
}

class _SimpleScaffold extends StatelessWidget {
  const _SimpleScaffold({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(padding: const EdgeInsets.all(20), children: children),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            Text(label, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _ProgressTile extends StatelessWidget {
  const _ProgressTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(subtitle),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: value),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.icon,
    required this.title,
    required this.status,
  });

  final IconData icon;
  final String title;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        minTileHeight: 76,
        leading: Icon(icon, size: 30),
        title: Text(title),
        subtitle: Text(status),
      ),
    );
  }
}

class _NumberedTile extends StatelessWidget {
  const _NumberedTile({required this.number, required this.title});

  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        minTileHeight: 72,
        leading: CircleAvatar(child: Text('$number')),
        title: Text(title),
      ),
    );
  }
}
