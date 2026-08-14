enum PlayerId {
  one,
  two;

  PlayerId get opponent => this == one ? two : one;
}

enum AssignedGroup { solids, stripes }

enum MatchPhase { breakShot, openTable, groupsAssigned, finished }

enum FoulReason {
  scratch,
  noObjectContact,
  wrongFirstContact,
  noRailOrPocket,
  illegalBreak,
  uncalledEightBall,
  timeout,
}

final class ShotReport {
  const ShotReport({
    this.firstContactNumber,
    this.pocketedNumbers = const <int>[],
    this.cushionContactsAfterFirst = 0,
    this.objectBallsToRailOnBreak = 0,
    this.cueScratched = false,
    this.timedOut = false,
    this.eightBallCalledCorrectly = false,
  });

  final int? firstContactNumber;
  final List<int> pocketedNumbers;
  final int cushionContactsAfterFirst;
  final int objectBallsToRailOnBreak;
  final bool cueScratched;
  final bool timedOut;
  final bool eightBallCalledCorrectly;

  bool get pocketedObjectBall => pocketedNumbers.any((number) => number != 0);
}

final class TurnResolution<TState> {
  const TurnResolution({
    required this.state,
    required this.fouls,
    required this.turnContinues,
    this.respotNumbers = const <int>[],
  });

  final TState state;
  final Set<FoulReason> fouls;
  final bool turnContinues;
  final List<int> respotNumbers;

  bool get isFoul => fouls.isNotEmpty;
}
