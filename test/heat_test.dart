import 'dart:math' as math;

import 'package:puff/game/sim/fracture.dart';
import 'package:puff/game/sim/heat.dart';
import 'package:puff/game/sim/shapes.dart';
import 'package:puff/game/tuning.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  const curve = HeatCurve();

  test('the warm-up is exactly the unescalated game', () {
    expect(curve.at(0), 0);
    expect(curve.at(curve.warmUp), 0);
    expect(curve.tierOf(curve.at(curve.warmUp)), 0);
  });

  test('heat is 1 at fullAt and max from overdriveAt on', () {
    expect(curve.at(curve.fullAt), closeTo(1, 1e-9));
    expect(curve.at(curve.overdriveAt), closeTo(curve.max, 1e-9));
    expect(curve.at(curve.overdriveAt + 600), closeTo(curve.max, 1e-9));
  });

  test('heat never falls as the run goes on', () {
    var previous = 0.0;
    for (var t = 0.0; t <= 300; t += 0.5) {
      final h = curve.at(t);
      expect(h, greaterThanOrEqualTo(previous));
      expect(h, lessThanOrEqualTo(curve.max));
      previous = h;
    }
  });

  test('tiers follow the heat', () {
    expect(curve.tierOf(0.01), 1);
    expect(curve.tierOf(0.5), 2);
    expect(curve.tierOf(1), 3);
    expect(curve.tierOf(curve.max), 4);
    expect(HeatCurve.tierNames.length, 5);
  });

  test('heatLerp hits cold, hot and overdrive values', () {
    expect(heatLerp(0, 2, 4, 5), 2);
    expect(heatLerp(0.5, 2, 4, 5), 3);
    expect(heatLerp(1, 2, 4, 5), 4);
    expect(heatLerp(1.25, 2, 4, 5), 4.5);
    expect(heatLerp(1.5, 2, 4, 5), 5);
    expect(heatLerp(1.5, 2, 4), 4);
  });

  test('a cold run blasts exactly as before', () {
    expect(Tuning.blastRadiusScale(0), 1);
    expect(Tuning.blastImpulseScale(0), 1);
    expect(Tuning.blastRadiusScale(1), Tuning.blastRadiusHot);
  });

  test('a full blast at the rim of a Kolos cracks it once it can appear', () {
    final heat = Tuning.kolosFromHeat;
    final radius = Tuning.blast.radiusOfEffect(1) * Tuning.blastRadiusScale(heat);
    final falloff = 1 - Tuning.kolosSizeMax / radius;
    final impulse =
        Tuning.blast.impulseScale *
        Tuning.blastImpulseScale(heat) *
        math.pow(falloff, Tuning.blast.falloffPower);
    expect(impulse, greaterThan(Tuning.kolosBreak));
  });

  test('a Kolos breaks one generation deeper than a spawned shape', () {
    const rules = FractureRules(
      maxDepth: Tuning.fractureMaxDepth,
      minFragmentSize: Tuning.minFragmentSize,
    );
    const kolos = ShapeSpec(
      kind: ShapeKind.poly,
      size: 1.25,
      sides: 8,
      breakThreshold: Tuning.kolosBreak,
    );
    var spec = kolos;
    var bodies = 1;
    for (var generation = 0; generation < Tuning.kolosFractureDepth; generation++) {
      final result = rules.fracture(
        spec: spec,
        generation: generation,
        localImpulse: Vector2(1, 0.3),
        maxDepth: Tuning.kolosFractureDepth,
      );
      expect(result.fragments, isNotEmpty, reason: 'generation $generation');
      bodies *= result.fragments.length;
      spec = result.fragments.first.spec;
    }
    // The last pieces are leaves, and the whole family fits the body budget.
    expect(spec.breakThreshold, double.infinity);
    expect(bodies, lessThanOrEqualTo(Tuning.maxBodies - Tuning.deepFractureBodies + 40));
    expect(
      rules.canFracture(spec, Tuning.kolosFractureDepth, maxDepth: Tuning.kolosFractureDepth),
      isFalse,
    );
  });
}
