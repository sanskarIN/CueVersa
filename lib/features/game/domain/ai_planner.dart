import 'dart:math' as math;

import 'ball.dart';
import 'game_mode.dart';
import 'shot.dart';
import 'table_geometry.dart';
import 'vector2.dart';

/// Geometry-based, deterministic offline AI.
///
/// Difficulty changes candidate scoring and bounded execution error. It never
/// moves balls directly or bypasses [PhysicsWorld]; it returns normal shot
/// parameters that use the same simulation as a human player.
final class AiPlanner {
  const AiPlanner({required this.difficulty, this.seed = 1});

  final AiDifficulty difficulty;
  final int seed;

  ShotParameters plan({
    required PoolBall cueBall,
    required Iterable<PoolBall> balls,
    required TableGeometry table,
    required Set<int> legalFirstContacts,
  }) {
    final candidates = <_Candidate>[];
    for (final ball in balls) {
      if (ball.isPocketed || !legalFirstContacts.contains(ball.number)) {
        continue;
      }
      for (final pocket in table.pockets) {
        final toPocket = pocket.center - ball.position;
        if (toPocket.length <= table.ballRadius) continue;
        final objectDirection = toPocket.normalized;
        final ghost = ball.position - (objectDirection * table.ballRadius * 2);
        final cuePath = ghost - cueBall.position;
        if (cuePath.length <= table.ballRadius * 2) continue;
        if (!_pathClear(
          cueBall.position,
          ghost,
          balls,
          cueBall.id,
          ball.id,
          table,
        )) {
          continue;
        }
        if (!_pathClear(
          ball.position,
          pocket.center,
          balls,
          ball.id,
          cueBall.id,
          table,
        )) {
          continue;
        }
        final cutCosine = cuePath.normalized
            .dot(objectDirection)
            .clamp(-1, 1)
            .toDouble();
        final cutPenalty = 1 - cutCosine;
        final scratchRisk = _scratchRisk(
          ghost,
          objectDirection,
          pocket.center,
          table,
        );
        final distance = cuePath.length + toPocket.length;
        final score = distance + (cutPenalty * 2.2) + (scratchRisk * 1.4);
        candidates.add(
          _Candidate(
            direction: cuePath.normalized,
            distance: distance,
            score: score,
          ),
        );
      }
    }

    if (candidates.isEmpty) {
      final fallback =
          balls
              .where(
                (ball) =>
                    !ball.isPocketed &&
                    legalFirstContacts.contains(ball.number),
              )
              .toList()
            ..sort((a, b) => a.number.compareTo(b.number));
      final direction = fallback.isEmpty
          ? const Vector2(1, 0)
          : (fallback.first.position - cueBall.position).normalized;
      return ShotParameters(
        direction: _withExecutionError(direction),
        power: _powerForDistance(.8),
      );
    }

    candidates.sort((a, b) => a.score.compareTo(b.score));
    final planningBreadth = switch (difficulty) {
      AiDifficulty.beginner => math.min(5, candidates.length),
      AiDifficulty.easy => math.min(4, candidates.length),
      AiDifficulty.intermediate => math.min(3, candidates.length),
      AiDifficulty.hard => math.min(2, candidates.length),
      AiDifficulty.expert || AiDifficulty.master => 1,
    };
    final selected = candidates[_randomIndex(planningBreadth)];
    return ShotParameters(
      direction: _withExecutionError(selected.direction),
      power: _powerForDistance(selected.distance),
      tipOffset: difficulty == AiDifficulty.master
          ? const Vector2(0, .2)
          : const Vector2.zero(),
    );
  }

  bool _pathClear(
    Vector2 start,
    Vector2 end,
    Iterable<PoolBall> balls,
    int ignoredA,
    int ignoredB,
    TableGeometry table,
  ) {
    final path = end - start;
    final lengthSquared = path.lengthSquared;
    if (lengthSquared <= 1e-12) return false;
    for (final obstacle in balls) {
      if (obstacle.isPocketed ||
          obstacle.id == ignoredA ||
          obstacle.id == ignoredB) {
        continue;
      }
      final projection = ((obstacle.position - start).dot(path) / lengthSquared)
          .clamp(0, 1)
          .toDouble();
      final nearest = start + (path * projection);
      if (nearest.distanceTo(obstacle.position) < table.ballRadius * 2.05) {
        return false;
      }
    }
    return true;
  }

  double _scratchRisk(
    Vector2 ghost,
    Vector2 objectDirection,
    Vector2 targetPocket,
    TableGeometry table,
  ) {
    final cueAfterContact = -objectDirection;
    final projected = ghost + (cueAfterContact * .45);
    final nearestPocket = table.pockets
        .map((pocket) => projected.distanceTo(pocket.center))
        .reduce(math.min);
    final targetBias = projected.distanceTo(targetPocket) < .2 ? .4 : 0.0;
    return nearestPocket < .16 ? 1 + targetBias : 0.0;
  }

  Vector2 _withExecutionError(Vector2 direction) {
    final maximumDegrees = switch (difficulty) {
      AiDifficulty.beginner => 6.5,
      AiDifficulty.easy => 4,
      AiDifficulty.intermediate => 2.2,
      AiDifficulty.hard => 1.1,
      AiDifficulty.expert => .45,
      AiDifficulty.master => .15,
    };
    final unit = ((_mix(seed) & 0xFFFF) / 0xFFFF) - .5;
    return direction.rotate(unit * 2 * maximumDegrees * math.pi / 180);
  }

  double _powerForDistance(double distance) {
    final base = (.24 + (distance / 3.2)).clamp(.28, .9).toDouble();
    final errorScale = switch (difficulty) {
      AiDifficulty.beginner => .18,
      AiDifficulty.easy => .12,
      AiDifficulty.intermediate => .07,
      AiDifficulty.hard => .04,
      AiDifficulty.expert => .02,
      AiDifficulty.master => .008,
    };
    final unit = (((_mix(seed + 91) >> 4) & 0xFFFF) / 0xFFFF) - .5;
    return (base + (unit * 2 * errorScale)).clamp(.18, 1).toDouble();
  }

  int _randomIndex(int upperBound) => _mix(seed + 37).abs() % upperBound;

  int _mix(int value) {
    var mixed = value & 0x7FFFFFFF;
    mixed = ((mixed * 1103515245) + 12345) & 0x7FFFFFFF;
    mixed ^= mixed >> 11;
    mixed = (mixed * 0x45D9F3B) & 0x7FFFFFFF;
    return mixed;
  }
}

final class _Candidate {
  const _Candidate({
    required this.direction,
    required this.distance,
    required this.score,
  });

  final Vector2 direction;
  final double distance;
  final double score;
}
