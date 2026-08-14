import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../../app/app_progress.dart';
import '../../../app/app_settings.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/ai_planner.dart';
import '../domain/eight_ball_rules.dart';
import '../domain/game_mode.dart';
import '../domain/nine_ball_rules.dart';
import '../domain/physics_event.dart';
import '../domain/physics_world.dart';
import '../domain/rack.dart';
import '../domain/rules.dart';
import '../domain/shot.dart';
import '../domain/table_geometry.dart';
import '../domain/vector2.dart';
import 'pool_table_view.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    required this.mode,
    required this.ruleSet,
    required this.difficulty,
    required this.settings,
    required this.progress,
    super.key,
  });

  final GameMode mode;
  final GameRuleSet ruleSet;
  final AiDifficulty difficulty;
  final AppSettings settings;
  final AppProgress progress;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  static const _table = TableGeometry();
  late final Ticker _ticker;
  late PhysicsWorld _world;
  Duration _lastFrame = Duration.zero;
  Vector2 _aimDirection = const Vector2(1, 0);
  Vector2 _tipOffset = const Vector2.zero();
  double _power = .58;
  bool _shotInProgress = false;
  bool _aiScheduled = false;
  int? _firstContact;
  final List<int> _pocketed = <int>[];
  final Set<int> _breakRailBalls = <int>{};
  int _cushionsAfterFirst = 0;
  EightBallState _eightBallState = EightBallState();
  NineBallState _nineBallState = NineBallState();

  PlayerId get _currentPlayer => widget.ruleSet == GameRuleSet.eightBall
      ? _eightBallState.currentPlayer
      : _nineBallState.currentPlayer;

  bool get _isAiTurn =>
      widget.mode == GameMode.versusAi && _currentPlayer == PlayerId.two;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _resetMatch(notify: false);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final playerLabel = widget.mode == GameMode.practice
        ? localizations.practice
        : _currentPlayer == PlayerId.one
        ? localizations.playerOne
        : widget.mode == GameMode.versusAi
        ? localizations.aiPlayer
        : localizations.playerTwo;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.gameTable),
        actions: <Widget>[
          IconButton(
            tooltip: localizations.resetRack,
            onPressed: _shotInProgress ? null : _confirmReset,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final landscape = constraints.maxWidth > constraints.maxHeight;
            final table = Padding(
              padding: const EdgeInsets.all(12),
              child: PoolTableView(
                world: _world,
                aimDirection: _aimDirection,
                showAimGuide: widget.mode == GameMode.practice || !_isAiTurn,
                semanticsLabel: localizations.tableBalls(
                  _world.balls.where((ball) => !ball.isPocketed).length,
                ),
                onAimChanged: _shotInProgress || _isAiTurn
                    ? (_) {}
                    : (direction) => setState(() => _aimDirection = direction),
              ),
            );
            final controls = _Controls(
              playerLabel: playerLabel,
              powerLabel: localizations.power,
              spinLabel: localizations.spin,
              shootLabel: localizations.shoot,
              aimHint: localizations.aimHint,
              power: _power,
              tipOffset: _tipOffset,
              enabled: !_shotInProgress && !_isAiTurn,
              leftHanded: widget.settings.leftHanded,
              vertical: landscape,
              onPowerChanged: (value) => setState(() => _power = value),
              onSpinChanged: (value) => setState(() => _tipOffset = value),
              onShoot: _shoot,
            );
            if (landscape) {
              return Row(
                children: <Widget>[
                  Expanded(flex: 7, child: table),
                  SizedBox(width: 290, child: controls),
                ],
              );
            }
            return Column(
              children: <Widget>[
                Expanded(child: Center(child: table)),
                controls,
              ],
            );
          },
        ),
      ),
    );
  }

  void _shoot() {
    final accepted = _world.strikeCueBall(
      ShotParameters(
        direction: _aimDirection,
        power: _power,
        tipOffset: _tipOffset,
      ),
    );
    if (!accepted) return;
    if (widget.settings.haptics) unawaited(HapticFeedback.lightImpact());
    _beginShot();
  }

  void _beginShot() {
    _firstContact = null;
    _pocketed.clear();
    _breakRailBalls.clear();
    _cushionsAfterFirst = 0;
    _shotInProgress = true;
    _lastFrame = Duration.zero;
    _ticker.start();
    setState(() {});
  }

  void _onTick(Duration elapsed) {
    if (_lastFrame == Duration.zero) {
      _lastFrame = elapsed;
      return;
    }
    _world.advance(elapsed - _lastFrame);
    _lastFrame = elapsed;
    _consumeEvents(_world.drainEvents());
    if (_world.isAtRest) {
      _ticker.stop();
      _finishShot();
    }
    if (mounted) setState(() {});
  }

  void _consumeEvents(List<PhysicsEvent> events) {
    for (final event in events) {
      if (event.type == PhysicsEventType.ballContact && _firstContact == null) {
        if (event.ballId == 0) _firstContact = event.otherBallId;
        if (event.otherBallId == 0) _firstContact = event.ballId;
      }
      if (event.type == PhysicsEventType.cushionContact) {
        if (_firstContact != null) _cushionsAfterFirst++;
        if (event.ballId != 0) _breakRailBalls.add(event.ballId);
      }
      if (event.type == PhysicsEventType.pocketed ||
          event.type == PhysicsEventType.scratch) {
        _pocketed.add(event.ballId);
      }
    }
  }

  void _finishShot() {
    if (!_shotInProgress) return;
    _shotInProgress = false;
    widget.progress.recordShot(
      pocketedBalls: _pocketed.where((number) => number != 0).length,
    );
    if (_world.cueBall.isPocketed) {
      _world.cueBall
        ..isPocketed = false
        ..position = Vector2(_table.width * .25, _table.height / 2);
    }
    if (widget.mode != GameMode.practice) {
      final report = ShotReport(
        firstContactNumber: _firstContact,
        pocketedNumbers: List<int>.of(_pocketed),
        cushionContactsAfterFirst: _cushionsAfterFirst,
        objectBallsToRailOnBreak: _breakRailBalls.length,
        cueScratched: _pocketed.contains(0),
        eightBallCalledCorrectly: true,
      );
      PlayerId? winner;
      if (widget.ruleSet == GameRuleSet.eightBall) {
        final result = const EightBallRules().applyShot(
          _eightBallState,
          report,
        );
        _eightBallState = result.state;
        winner = result.state.winner;
      } else {
        final result = const NineBallRules().applyShot(_nineBallState, report);
        _nineBallState = result.state;
        winner = result.state.winner;
      }
      if (winner != null) {
        widget.progress.recordMatch(won: winner == PlayerId.one);
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _showResult(winner!),
        );
        return;
      }
    }
    if (_isAiTurn) _scheduleAi();
  }

  void _scheduleAi() {
    if (_aiScheduled || !mounted) return;
    _aiScheduled = true;
    Future<void>.delayed(
      widget.settings.reducedMotion
          ? const Duration(milliseconds: 120)
          : const Duration(milliseconds: 650),
      () {
        _aiScheduled = false;
        if (!mounted || !_isAiTurn || !_world.isAtRest) return;
        final planner = AiPlanner(
          difficulty: widget.difficulty,
          seed: _world.tick,
        );
        final shot = planner.plan(
          cueBall: _world.cueBall,
          balls: _world.balls,
          table: _table,
          legalFirstContacts: _legalAiTargets(),
        );
        _world.strikeCueBall(shot);
        _aimDirection = shot.direction;
        _beginShot();
      },
    );
  }

  Set<int> _legalAiTargets() {
    if (widget.ruleSet == GameRuleSet.nineBall) {
      return <int>{_nineBallState.lowestBall};
    }
    final state = _eightBallState;
    if (state.phase == MatchPhase.breakShot) return <int>{1};
    if (state.phase == MatchPhase.openTable) {
      return state.ballsOnTable.where((number) => number != 8).toSet();
    }
    if (state.canShootEight(PlayerId.two)) return <int>{8};
    final group = state.groupFor(PlayerId.two);
    return state.ballsOnTable.where((number) {
      if (group == AssignedGroup.solids) return number >= 1 && number <= 7;
      return number >= 9 && number <= 15;
    }).toSet();
  }

  void _resetMatch({bool notify = true}) {
    final rack = widget.ruleSet == GameRuleSet.eightBall
        ? RackKind.eightBall
        : RackKind.nineBall;
    _world = PhysicsWorld(
      balls: RackFactory.create(rack, _table),
      table: _table,
    );
    _eightBallState = EightBallState();
    _nineBallState = NineBallState();
    _shotInProgress = false;
    _aiScheduled = false;
    _aimDirection = const Vector2(1, 0);
    _tipOffset = const Vector2.zero();
    _ticker.stop();
    if (notify && mounted) setState(() {});
  }

  Future<void> _confirmReset() async {
    final localizations = AppLocalizations.of(context);
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.resetRack),
        content: Text(localizations.resetRackWarning),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(localizations.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(localizations.confirm),
          ),
        ],
      ),
    );
    if (accepted ?? false) _resetMatch();
  }

  Future<void> _showResult(PlayerId winner) async {
    final localizations = AppLocalizations.of(context);
    final name = winner == PlayerId.one
        ? localizations.playerOne
        : widget.mode == GameMode.versusAi
        ? localizations.aiPlayer
        : localizations.playerTwo;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(localizations.results),
        content: Text('${localizations.winner}: $name'),
        actions: <Widget>[
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _resetMatch();
            },
            child: Text(localizations.restart),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(this.context);
            },
            child: Text(localizations.quitMatch),
          ),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.playerLabel,
    required this.powerLabel,
    required this.spinLabel,
    required this.shootLabel,
    required this.aimHint,
    required this.power,
    required this.tipOffset,
    required this.enabled,
    required this.leftHanded,
    required this.vertical,
    required this.onPowerChanged,
    required this.onSpinChanged,
    required this.onShoot,
  });

  final String playerLabel;
  final String powerLabel;
  final String spinLabel;
  final String shootLabel;
  final String aimHint;
  final double power;
  final Vector2 tipOffset;
  final bool enabled;
  final bool leftHanded;
  final bool vertical;
  final ValueChanged<double> onPowerChanged;
  final ValueChanged<Vector2> onSpinChanged;
  final VoidCallback onShoot;

  @override
  Widget build(BuildContext context) {
    final playerAndPower = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(playerLabel, style: Theme.of(context).textTheme.titleMedium),
        Text(aimHint, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Text('$powerLabel ${(power * 100).round()}%'),
        Slider(
          value: power,
          min: .1,
          onChanged: enabled ? onPowerChanged : null,
        ),
      ],
    );
    final spinControl = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(spinLabel),
        _SpinPad(value: tipOffset, enabled: enabled, onChanged: onSpinChanged),
      ],
    );
    final shootButton = FilledButton.icon(
      onPressed: enabled ? onShoot : null,
      icon: const Icon(Icons.sports_baseball_rounded),
      label: Text(shootLabel),
    );
    final horizontalChildren = <Widget>[
      Expanded(child: playerAndPower),
      const SizedBox(width: 12),
      spinControl,
      const SizedBox(width: 12),
      shootButton,
    ];
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: vertical
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    playerAndPower,
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: leftHanded
                          ? <Widget>[shootButton, spinControl]
                          : <Widget>[spinControl, shootButton],
                    ),
                  ],
                ),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: leftHanded
                    ? horizontalChildren.reversed.toList()
                    : horizontalChildren,
              ),
      ),
    );
  }
}

class _SpinPad extends StatelessWidget {
  const _SpinPad({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final Vector2 value;
  final bool enabled;
  final ValueChanged<Vector2> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context).spin,
      value: '${value.x.toStringAsFixed(1)}, ${value.y.toStringAsFixed(1)}',
      child: GestureDetector(
        onTapDown: enabled ? (details) => _update(details.localPosition) : null,
        onPanUpdate: enabled
            ? (details) => _update(details.localPosition)
            : null,
        child: CustomPaint(
          size: const Size.square(76),
          painter: _SpinPainter(value, Theme.of(context).colorScheme),
        ),
      ),
    );
  }

  void _update(Offset position) {
    final offset = position - const Offset(38, 38);
    final vector = Vector2(offset.dx / 38, -offset.dy / 38).clampMagnitude(1);
    onChanged(vector);
  }
}

final class _SpinPainter extends CustomPainter {
  const _SpinPainter(this.value, this.colors);

  final Vector2 value;
  final ColorScheme colors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    canvas.drawCircle(center, radius, Paint()..color = colors.surface);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = colors.outline
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawLine(
      Offset(center.dx, 5),
      Offset(center.dx, size.height - 5),
      Paint()..color = colors.outlineVariant,
    );
    canvas.drawLine(
      Offset(5, center.dy),
      Offset(size.width - 5, center.dy),
      Paint()..color = colors.outlineVariant,
    );
    canvas.drawCircle(
      center + Offset(value.x * radius * .72, -value.y * radius * .72),
      7,
      Paint()..color = colors.primary,
    );
  }

  @override
  bool shouldRepaint(_SpinPainter oldDelegate) => oldDelegate.value != value;
}
