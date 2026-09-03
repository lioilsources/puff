import 'package:puff/game/sim/fracture.dart';
import 'package:puff/game/sim/shapes.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  const rules = FractureRules(maxDepth: 2, minFragmentSize: 0.05);
  ShapeSpec spec(ShapeKind kind, {int sides = 6, double size = 0.5}) =>
      ShapeSpec(kind: kind, size: size, sides: sides, breakThreshold: 1);

  test('triangle splits into 3 triangles', () {
    final r = rules.fracture(
      spec: spec(ShapeKind.tri),
      generation: 0,
      localImpulse: Vector2(1, 0),
    );
    expect(r.fragments.length, 3);
    for (final f in r.fragments) {
      expect(f.spec.outline!.length, 3);
    }
  });

  test('square splits into 4 on diagonal impulse, 2 on axis impulse', () {
    final diag = rules.fracture(
      spec: spec(ShapeKind.square),
      generation: 0,
      localImpulse: Vector2(1, 1),
    );
    expect(diag.fragments.length, 4);
    final axis = rules.fracture(
      spec: spec(ShapeKind.square),
      generation: 0,
      localImpulse: Vector2(1, 0.05),
    );
    expect(axis.fragments.length, 2);
  });

  test('poly(n) splits into n triangles', () {
    final r = rules.fracture(
      spec: spec(ShapeKind.poly, sides: 7),
      generation: 0,
      localImpulse: Vector2(0, 1),
    );
    expect(r.fragments.length, 7);
  });

  test('circle never fractures', () {
    final r = rules.fracture(
      spec: spec(ShapeKind.circle),
      generation: 0,
      localImpulse: Vector2(1, 0),
    );
    expect(r.isEmpty, isTrue);
  });

  test('area is conserved across fragments', () {
    final s = spec(ShapeKind.poly, sides: 6);
    final r = rules.fracture(
      spec: s,
      generation: 0,
      localImpulse: Vector2(1, 0),
    );
    final total = r.fragments.fold(0.0, (acc, f) => acc + f.spec.area);
    expect(total, closeTo(s.area, 1e-9));
  });

  test('fragments stop fracturing at maxDepth', () {
    final s = spec(ShapeKind.tri);
    final gen1 = rules.fracture(
      spec: s,
      generation: 0,
      localImpulse: Vector2(1, 0),
    );
    final child = gen1.fragments.first;
    expect(rules.canFracture(child.spec, 1), isTrue);
    final gen2 = rules.fracture(
      spec: child.spec,
      generation: 1,
      localImpulse: Vector2(1, 0),
    );
    expect(gen2.fragments, isNotEmpty);
    for (final f in gen2.fragments) {
      expect(rules.canFracture(f.spec, 2), isFalse);
      expect(f.spec.breakThreshold, double.infinity);
    }
  });

  test('tiny pieces become dust', () {
    final r = rules.fracture(
      spec: spec(ShapeKind.tri, size: 0.04),
      generation: 0,
      localImpulse: Vector2(1, 0),
    );
    expect(r.fragments, isEmpty);
    expect(r.dust.length, 3);
  });

  test('fragment outlines are centered on their centroid', () {
    final r = rules.fracture(
      spec: spec(ShapeKind.square),
      generation: 0,
      localImpulse: Vector2(1, 1),
    );
    for (final f in r.fragments) {
      final c = polygonCentroid(f.spec.outline!);
      expect(c.length, lessThan(1e-9));
      expect(f.offset.length, greaterThan(0));
    }
  });
}
