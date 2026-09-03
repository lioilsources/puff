import 'package:puff/game/sim/modifier.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  test('chain order visits nearest neighbors greedily', () {
    final points = [Vector2(5, 0), Vector2(1, 0), Vector2(2, 0), Vector2(9, 9)];
    final order = chainOrder(Vector2.zero(), points, 3);
    expect(order, [1, 2, 0]);
  });

  test('chain order caps at available points', () {
    final order = chainOrder(Vector2.zero(), [Vector2(1, 1)], 5);
    expect(order, [0]);
  });

  test('gravity well pulls toward center and expires', () {
    final well = GravityWell(
      position: Vector2.zero(),
      strength: 10,
      radius: 3,
      duration: 2,
    );
    final a = well.accelerationAt(Vector2(1, 0));
    expect(a.x, lessThan(0));
    expect(well.accelerationAt(Vector2(4, 0)).length, 0);
    well.age = 1;
    final half = well.accelerationAt(Vector2(1, 0));
    expect(half.length, closeTo(a.length / 2, 1e-9));
    well.age = 2;
    expect(well.expired, isTrue);
    expect(well.accelerationAt(Vector2(1, 0)).length, 0);
  });
}
