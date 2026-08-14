import 'ball.dart';
import 'table_geometry.dart';
import 'vector2.dart';

enum RackKind { eightBall, nineBall }

abstract final class RackFactory {
  static List<PoolBall> create(RackKind kind, TableGeometry table) {
    return switch (kind) {
      RackKind.eightBall => _eightBall(table),
      RackKind.nineBall => _nineBall(table),
    };
  }

  static List<PoolBall> _eightBall(TableGeometry table) {
    const orderedNumbers = <int>[
      1,
      10,
      2,
      11,
      8,
      3,
      12,
      4,
      13,
      5,
      14,
      6,
      15,
      7,
      9,
    ];
    return <PoolBall>[
      _cue(table),
      ..._triangle(table, orderedNumbers, apexX: table.width * 0.72),
    ];
  }

  static List<PoolBall> _nineBall(TableGeometry table) {
    const orderedNumbers = <int>[1, 2, 3, 4, 9, 5, 6, 7, 8];
    final diameter = table.ballRadius * 2.002;
    final apex = Vector2(table.width * 0.72, table.height / 2);
    final offsets = <Vector2>[
      const Vector2(0, 0),
      Vector2(diameter * .866, -diameter / 2),
      Vector2(diameter * .866, diameter / 2),
      Vector2(diameter * 1.732, -diameter),
      Vector2(diameter * 1.732, 0),
      Vector2(diameter * 1.732, diameter),
      Vector2(diameter * 2.598, -diameter / 2),
      Vector2(diameter * 2.598, diameter / 2),
      Vector2(diameter * 3.464, 0),
    ];
    return <PoolBall>[
      _cue(table),
      for (var index = 0; index < orderedNumbers.length; index++)
        PoolBall(
          id: orderedNumbers[index],
          number: orderedNumbers[index],
          position: apex + offsets[index],
        ),
    ];
  }

  static PoolBall _cue(TableGeometry table) {
    return PoolBall(
      id: 0,
      number: 0,
      position: Vector2(table.width * 0.25, table.height / 2),
    );
  }

  static Iterable<PoolBall> _triangle(
    TableGeometry table,
    List<int> numbers, {
    required double apexX,
  }) sync* {
    final diameter = table.ballRadius * 2.002;
    var index = 0;
    for (var column = 0; column < 5; column++) {
      final x = apexX + (column * diameter * .8660254038);
      final firstY = (table.height / 2) - (column * diameter / 2);
      for (var row = 0; row <= column; row++) {
        final number = numbers[index++];
        yield PoolBall(
          id: number,
          number: number,
          position: Vector2(x, firstY + (row * diameter)),
        );
      }
    }
  }
}
