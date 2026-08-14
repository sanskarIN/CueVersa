import 'rules.dart';

enum EightBallRuleProfile { wpaInspired, casual, custom }

final class EightBallOptions {
  const EightBallOptions({
    this.profile = EightBallRuleProfile.wpaInspired,
    this.requireFourRailsOnDryBreak = true,
    this.assignGroupsOnBreak = false,
    this.callEightBall = true,
    this.earlyEightBallLoses = true,
  });

  factory EightBallOptions.casual() {
    return const EightBallOptions(
      profile: EightBallRuleProfile.casual,
      requireFourRailsOnDryBreak: false,
      callEightBall: false,
    );
  }

  final EightBallRuleProfile profile;
  final bool requireFourRailsOnDryBreak;
  final bool assignGroupsOnBreak;
  final bool callEightBall;
  final bool earlyEightBallLoses;
}

final class EightBallState {
  EightBallState({
    this.currentPlayer = PlayerId.one,
    this.phase = MatchPhase.breakShot,
    Map<PlayerId, AssignedGroup>? groups,
    Set<int>? ballsOnTable,
    this.ballInHand = false,
    this.winner,
  }) : groups = Map<PlayerId, AssignedGroup>.unmodifiable(
         groups ?? const <PlayerId, AssignedGroup>{},
       ),
       ballsOnTable = Set<int>.unmodifiable(
         ballsOnTable ??
             Set<int>.from(List<int>.generate(15, (index) => index + 1)),
       );

  final PlayerId currentPlayer;
  final MatchPhase phase;
  final Map<PlayerId, AssignedGroup> groups;
  final Set<int> ballsOnTable;
  final bool ballInHand;
  final PlayerId? winner;

  AssignedGroup? groupFor(PlayerId player) => groups[player];

  int remainingFor(PlayerId player) {
    final group = groupFor(player);
    if (group == null) return 7;
    return ballsOnTable.where((number) => _groupOf(number) == group).length;
  }

  bool canShootEight(PlayerId player) =>
      groupFor(player) != null && remainingFor(player) == 0;

  EightBallState copyWith({
    PlayerId? currentPlayer,
    MatchPhase? phase,
    Map<PlayerId, AssignedGroup>? groups,
    Set<int>? ballsOnTable,
    bool? ballInHand,
    PlayerId? winner,
    bool clearWinner = false,
  }) {
    return EightBallState(
      currentPlayer: currentPlayer ?? this.currentPlayer,
      phase: phase ?? this.phase,
      groups: groups ?? this.groups,
      ballsOnTable: ballsOnTable ?? this.ballsOnTable,
      ballInHand: ballInHand ?? this.ballInHand,
      winner: clearWinner ? null : winner ?? this.winner,
    );
  }
}

final class EightBallRules {
  const EightBallRules({this.options = const EightBallOptions()});

  final EightBallOptions options;

  TurnResolution<EightBallState> applyShot(
    EightBallState state,
    ShotReport shot,
  ) {
    if (state.phase == MatchPhase.finished) {
      throw StateError('A finished match cannot accept another shot.');
    }

    final shooter = state.currentPlayer;
    final isBreak = state.phase == MatchPhase.breakShot;
    final fouls = <FoulReason>{};
    if (shot.timedOut) fouls.add(FoulReason.timeout);
    if (shot.cueScratched || shot.pocketedNumbers.contains(0)) {
      fouls.add(FoulReason.scratch);
    }
    if (shot.firstContactNumber == null) {
      fouls.add(FoulReason.noObjectContact);
    }

    if (isBreak) {
      final legalDryBreak =
          !options.requireFourRailsOnDryBreak ||
          shot.objectBallsToRailOnBreak >= 4;
      if (!shot.pocketedObjectBall && !legalDryBreak) {
        fouls.add(FoulReason.illegalBreak);
      }
    } else if (shot.firstContactNumber != null &&
        !_isLegalFirstContact(state, shooter, shot.firstContactNumber!)) {
      fouls.add(FoulReason.wrongFirstContact);
    }

    if (!isBreak &&
        shot.firstContactNumber != null &&
        !shot.pocketedObjectBall &&
        shot.cushionContactsAfterFirst == 0) {
      fouls.add(FoulReason.noRailOrPocket);
    }

    final pocketed = Set<int>.from(shot.pocketedNumbers)..remove(0);
    final eightPocketed = pocketed.remove(8);
    final remaining = Set<int>.from(state.ballsOnTable)..removeAll(pocketed);

    if (eightPocketed) {
      if (isBreak) {
        // The 8 is respotted for both included profiles. The table stays open.
        remaining.add(8);
      } else {
        final legallyCleared = state.canShootEight(shooter);
        final callSatisfied =
            !options.callEightBall || shot.eightBallCalledCorrectly;
        final wins = fouls.isEmpty && legallyCleared && callSatisfied;
        if (!callSatisfied) fouls.add(FoulReason.uncalledEightBall);
        final winner = wins ? shooter : shooter.opponent;
        return TurnResolution<EightBallState>(
          state: state.copyWith(
            phase: MatchPhase.finished,
            ballsOnTable: remaining,
            winner: winner,
            ballInHand: false,
          ),
          fouls: fouls,
          turnContinues: false,
          respotNumbers: isBreak ? const <int>[8] : const <int>[],
        );
      }
    }

    var groups = state.groups;
    var phase = isBreak ? MatchPhase.openTable : state.phase;
    final mayAssign =
        state.phase == MatchPhase.openTable ||
        (isBreak && options.assignGroupsOnBreak);
    if (fouls.isEmpty && mayAssign) {
      final firstAssignable = shot.pocketedNumbers
          .where((number) => number != 0 && number != 8)
          .map(_groupOf)
          .whereType<AssignedGroup>()
          .firstOrNull;
      if (firstAssignable != null) {
        groups = <PlayerId, AssignedGroup>{
          shooter: firstAssignable,
          shooter.opponent: firstAssignable == AssignedGroup.solids
              ? AssignedGroup.stripes
              : AssignedGroup.solids,
        };
        phase = MatchPhase.groupsAssigned;
      }
    }

    final ownGroup = groups[shooter];
    final pocketedOwn = shot.pocketedNumbers.any(
      (number) => _groupOf(number) == ownGroup,
    );
    final pocketedWhileOpen =
        ownGroup == null &&
        shot.pocketedNumbers.any((number) => number != 0 && number != 8);
    final continues = fouls.isEmpty && (pocketedOwn || pocketedWhileOpen);
    final nextPlayer = continues ? shooter : shooter.opponent;

    return TurnResolution<EightBallState>(
      state: state.copyWith(
        currentPlayer: nextPlayer,
        phase: phase,
        groups: groups,
        ballsOnTable: remaining,
        ballInHand: fouls.isNotEmpty,
      ),
      fouls: fouls,
      turnContinues: continues,
      respotNumbers: isBreak && eightPocketed ? const <int>[8] : const <int>[],
    );
  }

  bool _isLegalFirstContact(
    EightBallState state,
    PlayerId shooter,
    int number,
  ) {
    if (state.phase == MatchPhase.openTable) {
      return number != 8;
    }
    if (state.canShootEight(shooter)) return number == 8;
    return _groupOf(number) == state.groupFor(shooter);
  }
}

AssignedGroup? _groupOf(int number) {
  if (number >= 1 && number <= 7) return AssignedGroup.solids;
  if (number >= 9 && number <= 15) return AssignedGroup.stripes;
  return null;
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
