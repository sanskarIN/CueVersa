import 'dart:math' as math;

import 'package:cue_versa/features/game/domain/ball.dart';
import 'package:cue_versa/features/game/domain/physics_event.dart';
import 'package:cue_versa/features/game/domain/physics_world.dart';
import 'package:cue_versa/features/game/domain/rack.dart';
import 'package:cue_versa/features/game/domain/shot.dart';
import 'package:cue_versa/features/game/domain/table_geometry.dart';
import 'package:cue_versa/features/game/domain/vector2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const table = TableGeometry();

  group('deterministic pool physics', () {
    test('head-on collision transfers most forward momentum', () {
      final world = _twoBallWorld(table: table);
      expect(world.strikeCueBall(_shot()), isTrue);

      final contact = _stepUntilEvent(world, PhysicsEventType.ballContact);

      expect(contact.otherBallId, 1);
      expect(world.balls[1].velocity.x, greaterThan(0));
      expect(world.balls[1].velocity.x, greaterThan(world.cueBall.velocity.x));
      expect(world.balls[1].velocity.y.abs(), lessThan(1e-8));
    });

    for (final angle in <int>[30, 60]) {
      test('$angle-degree cut sends object ball along contact normal', () {
        final radians = angle * math.pi / 180;
        final diameter = table.ballRadius * 2;
        final object = PoolBall(
          id: 1,
          number: 1,
          position: Vector2(
            .8,
            (table.height / 2) + (math.sin(radians) * diameter),
          ),
        );
        final world = PhysicsWorld(
          table: table,
          balls: <PoolBall>[_cue(table), object],
        );
        world.strikeCueBall(_shot(power: .6));

        _stepUntilEvent(world, PhysicsEventType.ballContact);

        final objectDirection = world.balls[1].velocity.normalized;
        expect(objectDirection.y, greaterThan(0));
        expect(objectDirection.x, greaterThan(0));
        expect(
          math.atan2(objectDirection.y, objectDirection.x),
          closeTo(radians, .13),
        );
      });
    }

    test('cushion reflection reverses normal velocity', () {
      final cue = _cue(table)
        ..position = const Vector2(.8, .4)
        ..velocity = const Vector2(.7, -1.2)
        ..rollingVelocity = const Vector2(.7, -1.2);
      final world = PhysicsWorld(table: table, balls: <PoolBall>[cue]);

      _stepUntilEvent(world, PhysicsEventType.cushionContact);

      expect(world.cueBall.velocity.y, greaterThan(0));
      expect(world.cueBall.velocity.x, greaterThan(0));
    });

    test('two-rail bank produces two distinct cushion contacts', () {
      final cue = _cue(table)
        ..position = const Vector2(.7, .4)
        ..velocity = const Vector2(1.3, 1)
        ..rollingVelocity = const Vector2(1.3, 1);
      final world = PhysicsWorld(table: table, balls: <PoolBall>[cue]);
      var cushionEvents = 0;
      for (var step = 0; step < 2000 && cushionEvents < 2; step++) {
        world.step();
        cushionEvents += world
            .drainEvents()
            .where((event) => event.type == PhysicsEventType.cushionContact)
            .length;
      }

      expect(cushionEvents, 2);
      expect(world.cueBall.isPocketed, isFalse);
    });

    test('draw retains reverse roll after the object-ball impact', () {
      final world = _twoBallWorld(table: table);
      world.strikeCueBall(_shot(power: .75, tipOffset: const Vector2(0, -1)));

      _stepUntilEvent(world, PhysicsEventType.ballContact);
      for (var step = 0; step < 300; step++) {
        world.step();
      }

      expect(world.cueBall.velocity.x, lessThan(0));
    });

    test('follow roll keeps cue ball moving through impact', () {
      final world = _twoBallWorld(table: table);
      world.strikeCueBall(_shot(power: .75, tipOffset: const Vector2(0, 1)));

      _stepUntilEvent(world, PhysicsEventType.ballContact);
      for (var step = 0; step < 120; step++) {
        world.step();
      }

      expect(world.cueBall.velocity.x, greaterThan(0));
    });

    test('side spin changes cushion exit compared with center ball', () {
      PhysicsWorld createWorld(double sideSpin) {
        final cue = _cue(table)
          ..position = const Vector2(2.2, .45)
          ..velocity = const Vector2(1, .25)
          ..rollingVelocity = const Vector2(1, .25)
          ..sideSpin = sideSpin;
        return PhysicsWorld(table: table, balls: <PoolBall>[cue]);
      }

      final center = createWorld(0);
      final english = createWorld(4);
      _stepUntilEvent(center, PhysicsEventType.cushionContact);
      _stepUntilEvent(english, PhysicsEventType.cushionContact);

      expect(english.cueBall.velocity.y, lessThan(center.cueBall.velocity.y));
    });

    test('pocket jaw rejects a grazing ball moving away from the throat', () {
      final cue = _cue(table)
        ..position = Vector2(table.cornerPocketRadius * .9, .001)
        ..velocity = const Vector2(.5, .1)
        ..rollingVelocity = const Vector2(.5, .1);
      final world = PhysicsWorld(table: table, balls: <PoolBall>[cue]);

      world.step();

      expect(world.cueBall.isPocketed, isFalse);
      expect(
        world.drainEvents().where(
          (event) => event.type == PhysicsEventType.scratch,
        ),
        isEmpty,
      );
    });

    test('cue ball entering a pocket produces a scratch', () {
      final cue = _cue(table)
        ..position = Vector2(table.width / 2, .09)
        ..velocity = const Vector2(0, -1)
        ..rollingVelocity = const Vector2(0, -1);
      final world = PhysicsWorld(table: table, balls: <PoolBall>[cue]);

      final event = _stepUntilEvent(world, PhysicsEventType.scratch);

      expect(event.ballId, 0);
      expect(world.cueBall.isPocketed, isTrue);
    });

    test('power break spreads multiple object balls', () {
      final initial = RackFactory.create(RackKind.eightBall, table);
      final initialPositions = <int, Vector2>{
        for (final ball in initial) ball.id: ball.position,
      };
      final world = PhysicsWorld(table: table, balls: initial);
      world.strikeCueBall(_shot());

      for (var step = 0; step < 1400; step++) {
        world.step();
      }

      final displaced = world.balls
          .where((ball) => !ball.isCueBall)
          .where(
            (ball) =>
                ball.isPocketed ||
                ball.position.distanceTo(initialPositions[ball.id]!) > .01,
          )
          .length;
      expect(displaced, greaterThanOrEqualTo(6));
    });

    test('identical rack and shot stream remains deterministic', () {
      PhysicsWorld createWorld() => PhysicsWorld(
        table: table,
        balls: RackFactory.create(RackKind.nineBall, table),
      );

      final first = createWorld();
      final second = createWorld();
      final shot = _shot(power: .83, tipOffset: const Vector2(.28, -.15));
      first.strikeCueBall(shot);
      second.strikeCueBall(shot);

      for (var step = 0; step < 900; step++) {
        first.step();
        second.step();
      }

      for (var index = 0; index < first.balls.length; index++) {
        expect(first.balls[index].position, second.balls[index].position);
        expect(first.balls[index].velocity, second.balls[index].velocity);
        expect(first.balls[index].isPocketed, second.balls[index].isPocketed);
      }
    });

    test('fixed step is independent of render-frame chunk size', () {
      PhysicsWorld createWorld() => PhysicsWorld(
        table: table,
        balls: RackFactory.create(RackKind.nineBall, table),
      );

      final coarse = createWorld()..strikeCueBall(_shot(power: .5));
      final fine = createWorld()..strikeCueBall(_shot(power: .5));
      for (var frame = 0; frame < 100; frame++) {
        coarse.advance(const Duration(milliseconds: 20));
      }
      for (var frame = 0; frame < 200; frame++) {
        fine.advance(const Duration(milliseconds: 10));
      }

      expect(coarse.tick, fine.tick);
      for (var index = 0; index < coarse.balls.length; index++) {
        expect(coarse.balls[index].position, fine.balls[index].position);
      }
    });
  });
}

PoolBall _cue(TableGeometry table) {
  return PoolBall(id: 0, number: 0, position: Vector2(.35, table.height / 2));
}

PhysicsWorld _twoBallWorld({required TableGeometry table}) {
  return PhysicsWorld(
    table: table,
    balls: <PoolBall>[
      _cue(table),
      PoolBall(id: 1, number: 1, position: Vector2(.78, table.height / 2)),
    ],
  );
}

ShotParameters _shot({
  double power = 1,
  Vector2 tipOffset = const Vector2.zero(),
}) {
  return ShotParameters(
    direction: const Vector2(1, 0),
    power: power,
    tipOffset: tipOffset,
  );
}

PhysicsEvent _stepUntilEvent(
  PhysicsWorld world,
  PhysicsEventType type, {
  int maximumSteps = 2400,
}) {
  for (var step = 0; step < maximumSteps; step++) {
    world.step();
    final events = world.drainEvents();
    for (final event in events) {
      if (event.type == type) return event;
    }
  }
  fail('Expected $type within $maximumSteps fixed steps.');
}
