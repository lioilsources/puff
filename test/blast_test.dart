import 'package:puff/game/sim/blast.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  const params = BlastParams(
    roeMin: 1,
    roeMax: 4,
    rMin: 0.25,
    falloffPower: 1.5,
    impulseScale: 10,
    torqueScale: 0.4,
  );

  test('radius of effect interpolates with energy', () {
    expect(params.radiusOfEffect(0), 1);
    expect(params.radiusOfEffect(1), 4);
    expect(params.radiusOfEffect(0.5), 2.5);
  });

  test('body outside radius receives nothing', () {
    final r = computeBlast(
      params: params,
      origin: Vector2.zero(),
      bodyPos: Vector2(5, 0),
      energy: 1,
      blastMultiplier: 1,
      randomSign: 1,
    );
    expect(r, isNull);
  });

  test('impulse points away from origin and falls off with distance', () {
    BlastResult at(double x) => computeBlast(
      params: params,
      origin: Vector2.zero(),
      bodyPos: Vector2(x, 0),
      energy: 1,
      blastMultiplier: 1,
      randomSign: 1,
    )!;
    final near = at(0.5);
    final far = at(3.0);
    expect(near.impulse.x, greaterThan(0));
    expect(near.impulse.y, closeTo(0, 1e-9));
    expect(near.magnitude, greaterThan(far.magnitude));
    expect(near.falloff, greaterThan(far.falloff));
  });

  test('distance is clamped to rMin at the center', () {
    final center = computeBlast(
      params: params,
      origin: Vector2.zero(),
      bodyPos: Vector2(0.0, 0.0),
      energy: 1,
      blastMultiplier: 1,
      randomSign: 1,
    )!;
    final atRMin = computeBlast(
      params: params,
      origin: Vector2.zero(),
      bodyPos: Vector2(0.25, 0.0),
      energy: 1,
      blastMultiplier: 1,
      randomSign: 1,
    )!;
    expect(center.magnitude, closeTo(atRMin.magnitude, 1e-9));
  });

  test('energy and environment multiplier scale the impulse linearly', () {
    BlastResult at(double e, double m) => computeBlast(
      params: params,
      origin: Vector2.zero(),
      bodyPos: Vector2(1, 0),
      energy: e,
      blastMultiplier: m,
      randomSign: 1,
      radiusOverride: 4,
    )!;
    expect(at(1, 2).magnitude, closeTo(2 * at(1, 1).magnitude, 1e-9));
    expect(at(0.5, 1).magnitude, closeTo(0.5 * at(1, 1).magnitude, 1e-9));
  });

  test('negative direction sign pulls inward (implosion)', () {
    final r = computeBlast(
      params: params,
      origin: Vector2.zero(),
      bodyPos: Vector2(1, 1),
      energy: 1,
      blastMultiplier: 1,
      randomSign: 1,
      directionSign: -1,
    )!;
    expect(r.impulse.x, lessThan(0));
    expect(r.impulse.y, lessThan(0));
  });
}
