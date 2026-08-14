import 'package:cue_versa/features/game/domain/eight_ball_rules.dart';
import 'package:cue_versa/features/game/domain/rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('8-ball rules', () {
    const rules = EightBallRules();

    test('dry break without four object-ball rails is a foul', () {
      final result = rules.applyShot(
        EightBallState(),
        const ShotReport(firstContactNumber: 1, objectBallsToRailOnBreak: 3),
      );

      expect(result.fouls, contains(FoulReason.illegalBreak));
      expect(result.state.currentPlayer, PlayerId.two);
      expect(result.state.ballInHand, isTrue);
      expect(result.state.phase, MatchPhase.openTable);
    });

    test('legal dry break keeps table open and changes player', () {
      final result = rules.applyShot(
        EightBallState(),
        const ShotReport(firstContactNumber: 1, objectBallsToRailOnBreak: 4),
      );

      expect(result.isFoul, isFalse);
      expect(result.state.phase, MatchPhase.openTable);
      expect(result.state.groups, isEmpty);
      expect(result.state.currentPlayer, PlayerId.two);
    });

    test('8-ball on break is respotted and does not end match', () {
      final result = rules.applyShot(
        EightBallState(),
        const ShotReport(
          firstContactNumber: 1,
          pocketedNumbers: <int>[8],
          objectBallsToRailOnBreak: 4,
        ),
      );

      expect(result.state.winner, isNull);
      expect(result.state.ballsOnTable, contains(8));
      expect(result.respotNumbers, <int>[8]);
    });

    test('first legal pocket on open table assigns groups', () {
      final state = EightBallState(phase: MatchPhase.openTable);
      final result = rules.applyShot(
        state,
        const ShotReport(firstContactNumber: 10, pocketedNumbers: <int>[10]),
      );

      expect(result.state.groupFor(PlayerId.one), AssignedGroup.stripes);
      expect(result.state.groupFor(PlayerId.two), AssignedGroup.solids);
      expect(result.state.phase, MatchPhase.groupsAssigned);
      expect(result.turnContinues, isTrue);
    });

    test('wrong group first contact gives opponent ball in hand', () {
      final state = _assignedState();
      final result = rules.applyShot(
        state,
        const ShotReport(firstContactNumber: 9, cushionContactsAfterFirst: 1),
      );

      expect(result.fouls, contains(FoulReason.wrongFirstContact));
      expect(result.state.currentPlayer, PlayerId.two);
      expect(result.state.ballInHand, isTrue);
    });

    test('legal contact needs a pocket or later cushion', () {
      final result = rules.applyShot(
        _assignedState(),
        const ShotReport(firstContactNumber: 1),
      );

      expect(result.fouls, contains(FoulReason.noRailOrPocket));
    });

    test('scratch is a foul even when own ball was pocketed', () {
      final result = rules.applyShot(
        _assignedState(),
        const ShotReport(
          firstContactNumber: 1,
          pocketedNumbers: <int>[0, 1],
          cueScratched: true,
        ),
      );

      expect(result.fouls, contains(FoulReason.scratch));
      expect(result.turnContinues, isFalse);
      expect(result.state.ballInHand, isTrue);
    });

    test('early 8-ball loses the match', () {
      final result = rules.applyShot(
        _assignedState(),
        const ShotReport(
          firstContactNumber: 1,
          pocketedNumbers: <int>[8],
          eightBallCalledCorrectly: true,
        ),
      );

      expect(result.state.phase, MatchPhase.finished);
      expect(result.state.winner, PlayerId.two);
    });

    test('cleared player wins on a legal called 8-ball', () {
      final state = _assignedState(ballsOnTable: <int>{8, 9, 10});
      final result = rules.applyShot(
        state,
        const ShotReport(
          firstContactNumber: 8,
          pocketedNumbers: <int>[8],
          eightBallCalledCorrectly: true,
        ),
      );

      expect(result.isFoul, isFalse);
      expect(result.state.winner, PlayerId.one);
      expect(result.state.phase, MatchPhase.finished);
    });

    test('uncalled 8-ball loses under default profile', () {
      final state = _assignedState(ballsOnTable: <int>{8, 9});
      final result = rules.applyShot(
        state,
        const ShotReport(firstContactNumber: 8, pocketedNumbers: <int>[8]),
      );

      expect(result.fouls, contains(FoulReason.uncalledEightBall));
      expect(result.state.winner, PlayerId.two);
    });

    test('legal own-group pocket continues turn', () {
      final result = rules.applyShot(
        _assignedState(),
        const ShotReport(firstContactNumber: 2, pocketedNumbers: <int>[2]),
      );

      expect(result.isFoul, isFalse);
      expect(result.turnContinues, isTrue);
      expect(result.state.currentPlayer, PlayerId.one);
      expect(result.state.ballsOnTable, isNot(contains(2)));
    });
  });
}

EightBallState _assignedState({Set<int>? ballsOnTable}) {
  return EightBallState(
    phase: MatchPhase.groupsAssigned,
    groups: const <PlayerId, AssignedGroup>{
      PlayerId.one: AssignedGroup.solids,
      PlayerId.two: AssignedGroup.stripes,
    },
    ballsOnTable: ballsOnTable,
  );
}
