import 'package:flutter/material.dart';

import '../../../app/app_progress.dart';
import '../../../app/app_settings.dart';
import '../../../l10n/app_localizations.dart';
import '../../game/domain/game_mode.dart';
import '../../game/presentation/game_screen.dart';

class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({
    required this.settings,
    required this.progress,
    super.key,
  });

  final AppSettings settings;
  final AppProgress progress;

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  GameRuleSet _ruleSet = GameRuleSet.eightBall;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localizations.selectMode)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            localizations.selectRules,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          SegmentedButton<GameRuleSet>(
            segments: <ButtonSegment<GameRuleSet>>[
              ButtonSegment<GameRuleSet>(
                value: GameRuleSet.eightBall,
                label: Text(localizations.eightBall),
              ),
              ButtonSegment<GameRuleSet>(
                value: GameRuleSet.nineBall,
                label: Text(localizations.nineBall),
              ),
            ],
            selected: <GameRuleSet>{_ruleSet},
            onSelectionChanged: (value) =>
                setState(() => _ruleSet = value.single),
          ),
          const SizedBox(height: 24),
          _ModeTile(
            icon: Icons.science_rounded,
            title: localizations.practice,
            subtitle: localizations.offlineOnly,
            onTap: () => _start(GameMode.practice),
          ),
          _ModeTile(
            icon: Icons.smart_toy_rounded,
            title: localizations.versusAi,
            subtitle: localizations.difficulty,
            onTap: _chooseDifficulty,
          ),
          _ModeTile(
            icon: Icons.people_alt_rounded,
            title: localizations.localTwoPlayer,
            subtitle: localizations.offlineOnly,
            onTap: () => _start(GameMode.localTwoPlayer),
          ),
          _ModeTile(
            icon: Icons.public_off_rounded,
            title: localizations.onlineComingSoon,
            subtitle: localizations.comingSoon,
          ),
          const SizedBox(height: 14),
          Text(
            localizations.notOfficialRules,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Future<void> _chooseDifficulty() async {
    final localizations = AppLocalizations.of(context);
    final labels = <AiDifficulty, String>{
      AiDifficulty.beginner: localizations.beginner,
      AiDifficulty.easy: localizations.easy,
      AiDifficulty.intermediate: localizations.intermediate,
      AiDifficulty.hard: localizations.hard,
      AiDifficulty.expert: localizations.expert,
      AiDifficulty.master: localizations.master,
    };
    final difficulty = await showModalBottomSheet<AiDifficulty>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              title: Text(
                localizations.difficulty,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            for (final entry in labels.entries)
              ListTile(
                title: Text(entry.value),
                onTap: () => Navigator.pop(context, entry.key),
              ),
          ],
        ),
      ),
    );
    if (difficulty != null && mounted) {
      _start(GameMode.versusAi, difficulty: difficulty);
    }
  }

  void _start(
    GameMode mode, {
    AiDifficulty difficulty = AiDifficulty.intermediate,
  }) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => GameScreen(
          mode: mode,
          ruleSet: _ruleSet,
          difficulty: difficulty,
          settings: widget.settings,
          progress: widget.progress,
        ),
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          enabled: onTap != null,
          minTileHeight: 78,
          leading: Icon(icon, size: 30),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Icon(
            onTap == null ? Icons.lock_clock_rounded : Icons.chevron_right,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
