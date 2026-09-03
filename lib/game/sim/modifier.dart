import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

import 'explosion_event.dart';

enum ModifierKind { pressure, implosion, magnet, gravityWell, chainSpark }

/// Static description of a modifier plus the pure math it needs. The physics
/// layer (`physics/modifiers.dart`) turns these into impulses and forces.
class ModifierSpec {
  const ModifierSpec({
    required this.kind,
    required this.name,
    required this.description,
    required this.explosionKind,
  });

  final ModifierKind kind;
  final String name;
  final String description;
  final ExplosionKind explosionKind;

  static const pressure = ModifierSpec(
    kind: ModifierKind.pressure,
    name: 'Pressure',
    description: 'Plain outward blast.',
    explosionKind: ExplosionKind.pressure,
  );
  static const implosion = ModifierSpec(
    kind: ModifierKind.implosion,
    name: 'Implosion',
    description: 'Pull everything in, then a small pop.',
    explosionKind: ExplosionKind.implosion,
  );
  static const magnet = ModifierSpec(
    kind: ModifierKind.magnet,
    name: 'Magnet',
    description: 'Only metal shapes react, but hard.',
    explosionKind: ExplosionKind.magnet,
  );
  static const gravityWell = ModifierSpec(
    kind: ModifierKind.gravityWell,
    name: 'Gravity well',
    description: 'Leaves a decaying attractor behind.',
    explosionKind: ExplosionKind.gravityWell,
  );
  static const chainSpark = ModifierSpec(
    kind: ModifierKind.chainSpark,
    name: 'Chain spark',
    description: 'Arcs jump between the nearest shapes.',
    explosionKind: ExplosionKind.chainSpark,
  );

  static const all = [pressure, implosion, magnet, gravityWell, chainSpark];

  static ModifierSpec byKind(ModifierKind kind) =>
      all.firstWhere((m) => m.kind == kind);
}

/// Implosion timing/strength knobs.
class ImplosionParams {
  const ImplosionParams({
    required this.pullMultiplier,
    required this.popDelay,
    required this.popEnergyFraction,
  });

  final double pullMultiplier;
  final double popDelay;
  final double popEnergyFraction;
}

/// A persistent radial attractor.
class GravityWell {
  GravityWell({
    required this.position,
    required this.strength,
    required this.radius,
    required this.duration,
  });

  final Vector2 position;

  /// Peak acceleration (m/s^2) at the center, decays linearly with time.
  final double strength;
  final double radius;
  final double duration;
  double age = 0;

  bool get expired => age >= duration;

  /// 1 -> 0 over the lifetime.
  double get life => (1 - age / duration).clamp(0.0, 1.0);

  /// Acceleration to apply to a body at [bodyPos]; zero outside the radius.
  Vector2 accelerationAt(Vector2 bodyPos) {
    final d = position - bodyPos;
    final dist = d.length;
    if (dist > radius || dist < 1e-6) {
      return Vector2.zero();
    }
    // Strongest near the rim's inner half, softened at the very center so
    // bodies orbit/jitter rather than getting pinned.
    final t = dist / radius;
    final falloff = math.sin(t * math.pi).clamp(0.0, 1.0) * 0.7 + 0.3 * (1 - t);
    return d / dist * (strength * life * falloff);
  }
}

/// Greedy nearest-neighbor chain from [origin] through up to [count] points.
/// Returns indices into [points] in visiting order.
List<int> chainOrder(Vector2 origin, List<Vector2> points, int count) {
  final remaining = List<int>.generate(points.length, (i) => i);
  final order = <int>[];
  var current = origin;
  while (order.length < count && remaining.isNotEmpty) {
    var bestIndex = -1;
    var bestDist = double.infinity;
    for (final i in remaining) {
      final d = points[i].distanceToSquared(current);
      if (d < bestDist) {
        bestDist = d;
        bestIndex = i;
      }
    }
    order.add(bestIndex);
    remaining.remove(bestIndex);
    current = points[bestIndex];
  }
  return order;
}
