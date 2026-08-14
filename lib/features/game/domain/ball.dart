import 'vector2.dart';

enum BallGroup { cue, solid, eight, stripe, nine }

final class PoolBall {
  PoolBall({
    required this.id,
    required this.number,
    required this.position,
    Vector2? velocity,
    Vector2? rollingVelocity,
    this.sideSpin = 0,
    this.isPocketed = false,
  }) : velocity = velocity ?? const Vector2.zero(),
       rollingVelocity = rollingVelocity ?? const Vector2.zero();

  final int id;
  final int number;
  Vector2 position;
  Vector2 velocity;

  /// Surface velocity created by top/back spin in table coordinates.
  /// Cloth friction gradually couples this to [velocity].
  Vector2 rollingVelocity;

  /// Axial spin in normalized simulation units. Positive is right English.
  double sideSpin;
  bool isPocketed;

  bool get isCueBall => number == 0;

  BallGroup get group {
    if (number == 0) return BallGroup.cue;
    if (number == 8) return BallGroup.eight;
    if (number == 9) return BallGroup.nine;
    if (number < 8) return BallGroup.solid;
    return BallGroup.stripe;
  }

  double get speed => velocity.length;

  bool get isMoving => !isPocketed && speed > 0;

  PoolBall copy() {
    return PoolBall(
      id: id,
      number: number,
      position: position,
      velocity: velocity,
      rollingVelocity: rollingVelocity,
      sideSpin: sideSpin,
      isPocketed: isPocketed,
    );
  }

  void stop() {
    velocity = const Vector2.zero();
    rollingVelocity = const Vector2.zero();
    sideSpin = 0;
  }
}
