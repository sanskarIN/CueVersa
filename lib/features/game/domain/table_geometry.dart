import 'vector2.dart';

final class TableGeometry {
  const TableGeometry({
    this.width = 2.54,
    this.height = 1.27,
    this.ballRadius = 0.028575,
    this.cornerPocketRadius = 0.063,
    this.sidePocketRadius = 0.067,
    this.cushionRestitution = 0.86,
    this.ballRestitution = 0.94,
    this.rollingDeceleration = 0.055,
    this.slidingCoupling = 1.6,
    this.stopSpeed = 0.008,
  });

  final double width;
  final double height;
  final double ballRadius;
  final double cornerPocketRadius;
  final double sidePocketRadius;
  final double cushionRestitution;
  final double ballRestitution;
  final double rollingDeceleration;
  final double slidingCoupling;
  final double stopSpeed;

  List<Pocket> get pockets => <Pocket>[
    Pocket(index: 0, center: const Vector2(0, 0), radius: cornerPocketRadius),
    Pocket(index: 1, center: Vector2(width / 2, 0), radius: sidePocketRadius),
    Pocket(index: 2, center: Vector2(width, 0), radius: cornerPocketRadius),
    Pocket(index: 3, center: Vector2(0, height), radius: cornerPocketRadius),
    Pocket(
      index: 4,
      center: Vector2(width / 2, height),
      radius: sidePocketRadius,
    ),
    Pocket(
      index: 5,
      center: Vector2(width, height),
      radius: cornerPocketRadius,
    ),
  ];
}

final class Pocket {
  const Pocket({
    required this.index,
    required this.center,
    required this.radius,
  });

  final int index;
  final Vector2 center;
  final double radius;
}
