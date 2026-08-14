import 'dart:math' as math;

import 'ball.dart';
import 'physics_event.dart';
import 'shot.dart';
import 'table_geometry.dart';
import 'vector2.dart';

/// Fixed-step, deterministic 2D pool simulation.
///
/// The world intentionally accepts only shot inputs, never final ball states.
/// The same ordered rack and shot stream produces the same state on a matching
/// Dart runtime. Online competitive play still requires an authoritative
/// service and protocol/version checks before this can be treated as secure.
final class PhysicsWorld {
  PhysicsWorld({
    required Iterable<PoolBall> balls,
    TableGeometry? table,
    this.ticksPerSecond = 240,
  }) : table = table ?? const TableGeometry(),
       balls = balls.map((ball) => ball.copy()).toList(growable: false),
       assert(ticksPerSecond >= 120);

  final TableGeometry table;
  final int ticksPerSecond;
  final List<PoolBall> balls;
  final List<PhysicsEvent> _events = <PhysicsEvent>[];

  double _accumulatorSeconds = 0;
  bool _wasMoving = false;
  int tick = 0;

  double get fixedDeltaSeconds => 1 / ticksPerSecond;

  List<PhysicsEvent> drainEvents() {
    final result = List<PhysicsEvent>.unmodifiable(_events);
    _events.clear();
    return result;
  }

  PoolBall get cueBall => balls.firstWhere((ball) => ball.isCueBall);

  bool get isAtRest => balls.every(
    (ball) => ball.isPocketed || ball.velocity.length <= table.stopSpeed,
  );

  bool strikeCueBall(ShotParameters shot) {
    final cue = cueBall;
    if (cue.isPocketed || !isAtRest || shot.power <= 0) {
      return false;
    }
    final speed = shot.speedMetresPerSecond;
    final clampedTip = shot.tipOffset.clampMagnitude(1);
    cue.velocity = shot.direction * speed;
    // Full low-tip contact begins with reverse surface velocity, which permits
    // a draw response after the cue ball loses linear speed on impact.
    cue.rollingVelocity =
        shot.direction * (speed * (1 + (clampedTip.y * 1.35)));
    cue.sideSpin = clampedTip.x * speed;
    _wasMoving = true;
    return true;
  }

  /// Advances by wall-clock time while retaining a fixed physics delta.
  /// Large gaps are capped to avoid a resume-time simulation spiral.
  void advance(Duration elapsed) {
    _accumulatorSeconds += math.min(
      elapsed.inMicroseconds / Duration.microsecondsPerSecond,
      0.25,
    );
    final delta = fixedDeltaSeconds;
    while (_accumulatorSeconds + 1e-12 >= delta) {
      step();
      _accumulatorSeconds -= delta;
    }
  }

  void step() {
    tick++;
    final delta = fixedDeltaSeconds;

    for (final ball in balls) {
      if (ball.isPocketed) continue;
      ball.position += ball.velocity * delta;
      _applyCloth(ball, delta);
    }

    _resolveBallContacts();

    for (final ball in balls) {
      if (ball.isPocketed) continue;
      if (_tryPocket(ball)) continue;
      _resolveCushion(ball);
      if (ball.velocity.length <= table.stopSpeed &&
          ball.rollingVelocity.length <= table.stopSpeed) {
        ball.stop();
      }
    }

    final moving = !isAtRest;
    if (_wasMoving && !moving) {
      _events.add(
        PhysicsEvent(type: PhysicsEventType.stopped, tick: tick, ballId: -1),
      );
    }
    _wasMoving = moving;
  }

  void simulateUntilRest({double timeoutSeconds = 30}) {
    final maximumTicks = (timeoutSeconds * ticksPerSecond).ceil();
    for (var count = 0; count < maximumTicks && !isAtRest; count++) {
      step();
    }
  }

  void _applyCloth(PoolBall ball, double delta) {
    final slip = ball.rollingVelocity - ball.velocity;
    if (slip.lengthSquared > 1e-12) {
      final coupling = slip.clampMagnitude(table.slidingCoupling * delta);
      ball.velocity += coupling * 0.68;
      ball.rollingVelocity -= coupling * 0.32;
    }

    ball.velocity = _decelerate(
      ball.velocity,
      table.rollingDeceleration * delta,
    );
    ball.rollingVelocity = _decelerate(
      ball.rollingVelocity,
      table.rollingDeceleration * delta * 0.65,
    );
    ball.sideSpin = _moveTowardZero(
      ball.sideSpin,
      table.rollingDeceleration * delta * 1.8,
    );
  }

  Vector2 _decelerate(Vector2 value, double amount) {
    final magnitude = value.length;
    if (magnitude <= amount) return const Vector2.zero();
    return value * ((magnitude - amount) / magnitude);
  }

  double _moveTowardZero(double value, double amount) {
    if (value.abs() <= amount) return 0;
    return value - (value.sign * amount);
  }

  void _resolveBallContacts() {
    final diameter = table.ballRadius * 2;
    final diameterSquared = diameter * diameter;
    for (var first = 0; first < balls.length - 1; first++) {
      final a = balls[first];
      if (a.isPocketed) continue;
      for (var second = first + 1; second < balls.length; second++) {
        final b = balls[second];
        if (b.isPocketed) continue;
        final separation = b.position - a.position;
        if (separation.lengthSquared > diameterSquared) continue;

        final distance = separation.length;
        final normal = distance <= 1e-10
            ? const Vector2(1, 0)
            : separation / distance;
        final penetration = diameter - distance;
        if (penetration > 0) {
          final correction = normal * ((penetration / 2) + 1e-7);
          a.position -= correction;
          b.position += correction;
        }

        final relativeVelocity = b.velocity - a.velocity;
        final normalSpeed = relativeVelocity.dot(normal);
        if (normalSpeed >= 0) continue;

        final impulseMagnitude =
            (-(1 + table.ballRestitution) * normalSpeed) / 2;
        final impulse = normal * impulseMagnitude;
        a.velocity -= impulse;
        b.velocity += impulse;

        // A small tangential impulse approximates ball-ball throw without
        // introducing unstable full rigid-body angular dynamics.
        final tangent = normal.perpendicular;
        final tangentSpeed = relativeVelocity.dot(tangent);
        final tangentImpulse = tangent * (tangentSpeed * 0.018);
        a.velocity += tangentImpulse;
        b.velocity -= tangentImpulse;

        _events.add(
          PhysicsEvent(
            type: PhysicsEventType.ballContact,
            tick: tick,
            ballId: a.id,
            otherBallId: b.id,
          ),
        );
      }
    }
  }

  bool _tryPocket(PoolBall ball) {
    for (final pocket in table.pockets) {
      final toPocket = pocket.center - ball.position;
      final distance = toPocket.length;
      if (distance > pocket.radius) continue;

      final inwardSpeed = distance <= 1e-10
          ? ball.speed
          : ball.velocity.dot(toPocket / distance);
      final insideThroat = distance <= pocket.radius * 0.56;
      if (!insideThroat && inwardSpeed <= table.stopSpeed) {
        continue;
      }

      ball.isPocketed = true;
      ball.position = pocket.center;
      ball.stop();
      _events.add(
        PhysicsEvent(
          type: ball.isCueBall
              ? PhysicsEventType.scratch
              : PhysicsEventType.pocketed,
          tick: tick,
          ballId: ball.id,
          pocketIndex: pocket.index,
        ),
      );
      return true;
    }
    return false;
  }

  void _resolveCushion(PoolBall ball) {
    final radius = table.ballRadius;
    var hit = false;
    var x = ball.position.x;
    var y = ball.position.y;
    var velocity = ball.velocity;
    var rolling = ball.rollingVelocity;

    if (x < radius) {
      x = radius + (radius - x);
      velocity = Vector2(
        velocity.x.abs() * table.cushionRestitution,
        velocity.y,
      );
      rolling = Vector2(rolling.x.abs() * table.cushionRestitution, rolling.y);
      velocity += Vector2(0, ball.sideSpin * 0.025);
      hit = true;
    } else if (x > table.width - radius) {
      x = (table.width - radius) - (x - (table.width - radius));
      velocity = Vector2(
        -velocity.x.abs() * table.cushionRestitution,
        velocity.y,
      );
      rolling = Vector2(-rolling.x.abs() * table.cushionRestitution, rolling.y);
      velocity += Vector2(0, -ball.sideSpin * 0.025);
      hit = true;
    }

    if (y < radius) {
      y = radius + (radius - y);
      velocity = Vector2(
        velocity.x,
        velocity.y.abs() * table.cushionRestitution,
      );
      rolling = Vector2(rolling.x, rolling.y.abs() * table.cushionRestitution);
      velocity += Vector2(-ball.sideSpin * 0.025, 0);
      hit = true;
    } else if (y > table.height - radius) {
      y = (table.height - radius) - (y - (table.height - radius));
      velocity = Vector2(
        velocity.x,
        -velocity.y.abs() * table.cushionRestitution,
      );
      rolling = Vector2(rolling.x, -rolling.y.abs() * table.cushionRestitution);
      velocity += Vector2(ball.sideSpin * 0.025, 0);
      hit = true;
    }

    if (hit) {
      ball.position = Vector2(x, y);
      ball.velocity = velocity;
      ball.rollingVelocity = rolling;
      ball.sideSpin *= 0.72;
      _events.add(
        PhysicsEvent(
          type: PhysicsEventType.cushionContact,
          tick: tick,
          ballId: ball.id,
        ),
      );
    }
  }
}
