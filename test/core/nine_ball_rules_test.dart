import 'package:cue_versa/features/game/domain/nine_ball_rules.dart';
import 'package:cue_versa/features/game/domain/rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('9-ball rules', () {
    const rules = NineBallRules();

    test('lowest ball must be contacted first', () {
      final result = rules.applyShot(
        NineBallState(),
        const ShotReport(firstContactNumber: 2, cushionContactsAfterFirst: 1),
      );

      expect(result.fouls, contains(FoulReason.wrongFirstContact));
      expect(result.state.currentPlayer, PlayerId.two);
      expect(result.state.ballInHand, isTrue);
    });

    test('legal combination pocketing 9 wins', () {
      final result = rules.applyShot(
        NineBallState(),
        const ShotReport(firstContactNumber: 1, pocketedNumbers: <int>[9]),
      );

      expect(result.isFoul, isFalse);
      expect(result.state.winner, PlayerId.one);
      expect(result.state.ballsOnTable, isNot(contains(9)));
    });

    test('9-ball pocketed on a scratch is respotted', () {
      final result = rules.applyShot(
        NineBallState(),
        const ShotReport(
          firstContactNumber: 1,
          pocketedNumbers: <int>[0, 9],
          cueScratched: true,
        ),
      );

      expect(result.state.winner, isNull);
      expect(result.state.ballsOnTable, contains(9));
      expect(result.respotNumbers, <int>[9]);
      expect(result.state.ballInHand, isTrue);
    });

    test('legal numbered pocket continues turn and removes ball', () {
      final result = rules.applyShot(
        NineBallState(),
        const ShotReport(firstContactNumber: 1, pocketedNumbers: <int>[1]),
      );

      expect(result.turnContinues, isTrue);
      expect(result.state.currentPlayer, PlayerId.one);
      expect(result.state.lowestBall, 2);
    });

    test('no rail or pocket after contact is a foul', () {
      final result = rules.applyShot(
        NineBallState(),
        const ShotReport(firstContactNumber: 1),
      );

      expect(result.fouls, contains(FoulReason.noRailOrPocket));
    });

    test('timeout gives the opponent ball in hand', () {
      final result = rules.applyShot(
        NineBallState(),
        const ShotReport(timedOut: true),
      );

      expect(
        result.fouls,
        containsAll(<FoulReason>[
          FoulReason.timeout,
          FoulReason.noObjectContact,
        ]),
      );
      expect(result.state.currentPlayer, PlayerId.two);
      expect(result.state.ballInHand, isTrue);
    });
  });
}
