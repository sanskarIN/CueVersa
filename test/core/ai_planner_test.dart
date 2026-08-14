import 'package:cue_versa/features/game/domain/ai_planner.dart';
import 'package:cue_versa/features/game/domain/ball.dart';
import 'package:cue_versa/features/game/domain/game_mode.dart';
import 'package:cue_versa/features/game/domain/table_geometry.dart';
import 'package:cue_versa/features/game/domain/vector2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const table = TableGeometry();
  final cue = PoolBall(id: 0, number: 0, position: const Vector2(.35, .63));
  final balls = <PoolBall>[
    cue,
    PoolBall(id: 1, number: 1, position: const Vector2(.85, .63)),
    PoolBall(id: 2, number: 2, position: const Vector2(.72, .94)),
  ];

  test('planner returns a normalized, bounded physical shot', () {
    final shot = const AiPlanner(difficulty: AiDifficulty.hard, seed: 42).plan(
      cueBall: cue,
      balls: balls,
      table: table,
      legalFirstContacts: <int>{1},
    );

    expect(shot.direction.length, closeTo(1, 1e-12));
    expect(shot.power, inInclusiveRange(0, 1));
    expect(
      shot.direction.dot(balls[1].position - cue.position),
      greaterThan(0),
    );
  });

  test('same seed and state yield the same AI shot', () {
    const planner = AiPlanner(difficulty: AiDifficulty.expert, seed: 817);
    final first = planner.plan(
      cueBall: cue,
      balls: balls,
      table: table,
      legalFirstContacts: <int>{1},
    );
    final second = planner.plan(
      cueBall: cue,
      balls: balls,
      table: table,
      legalFirstContacts: <int>{1},
    );

    expect(first.direction, second.direction);
    expect(first.power, second.power);
  });

  test('empty legal target set still returns a safe fallback', () {
    final shot = const AiPlanner(difficulty: AiDifficulty.beginner, seed: 3)
        .plan(
          cueBall: cue,
          balls: balls,
          table: table,
          legalFirstContacts: <int>{},
        );

    expect(shot.direction.length, closeTo(1, 1e-12));
    expect(shot.power, inInclusiveRange(.18, 1));
  });
}
