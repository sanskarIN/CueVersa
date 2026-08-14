import 'rules.dart';

final class NineBallState {
  NineBallState({
    this.currentPlayer = PlayerId.one,
    Set<int>? ballsOnTable,
    this.ballInHand = false,
    this.winner,
  }) : ballsOnTable = Set<int>.unmodifiable(
         ballsOnTable ??
             Set<int>.from(List<int>.generate(9, (index) => index + 1)),
       );

  final PlayerId currentPlayer;
  final Set<int> ballsOnTable;
  final bool ballInHand;
  final PlayerId? winner;

  bool get isFinished => winner != null;
  int get lowestBall => ballsOnTable.reduce((a, b) => a < b ? a : b);

  NineBallState copyWith({
    PlayerId? currentPlayer,
    Set<int>? ballsOnTable,
    bool? ballInHand,
    PlayerId? winner,
  }) {
    return NineBallState(
      currentPlayer: currentPlayer ?? this.currentPlayer,
      ballsOnTable: ballsOnTable ?? this.ballsOnTable,
      ballInHand: ballInHand ?? this.ballInHand,
      winner: winner ?? this.winner,
    );
  }
}

final class NineBallRules {
  const NineBallRules();

  TurnResolution<NineBallState> applyShot(
    NineBallState state,
    ShotReport shot,
  ) {
    if (state.isFinished) {
      throw StateError('A finished match cannot accept another shot.');
    }
    final fouls = <FoulReason>{};
    if (shot.timedOut) fouls.add(FoulReason.timeout);
    if (shot.cueScratched || shot.pocketedNumbers.contains(0)) {
      fouls.add(FoulReason.scratch);
    }
    if (shot.firstContactNumber == null) {
      fouls.add(FoulReason.noObjectContact);
    } else if (shot.firstContactNumber != state.lowestBall) {
      fouls.add(FoulReason.wrongFirstContact);
    }
    if (shot.firstContactNumber != null &&
        !shot.pocketedObjectBall &&
        shot.cushionContactsAfterFirst == 0) {
      fouls.add(FoulReason.noRailOrPocket);
    }

    final pocketed = Set<int>.from(shot.pocketedNumbers)..remove(0);
    final ninePocketed = pocketed.contains(9);
    final remaining = Set<int>.from(state.ballsOnTable)..removeAll(pocketed);

    if (ninePocketed && fouls.isEmpty) {
      return TurnResolution<NineBallState>(
        state: state.copyWith(
          ballsOnTable: remaining,
          winner: state.currentPlayer,
          ballInHand: false,
        ),
        fouls: fouls,
        turnContinues: false,
      );
    }

    final respot = <int>[];
    if (ninePocketed && fouls.isNotEmpty) {
      remaining.add(9);
      respot.add(9);
    }
    final continues = fouls.isEmpty && pocketed.isNotEmpty;
    return TurnResolution<NineBallState>(
      state: state.copyWith(
        currentPlayer: continues
            ? state.currentPlayer
            : state.currentPlayer.opponent,
        ballsOnTable: remaining,
        ballInHand: fouls.isNotEmpty,
      ),
      fouls: fouls,
      turnContinues: continues,
      respotNumbers: respot,
    );
  }
}
