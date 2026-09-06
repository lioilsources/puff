import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

import '../tuning.dart';

/// One expanding surface ring, left by a detonation in water.
///
/// The background shader draws it and [EnvironmentForces] lets the front nudge
/// the bodies it sweeps past, so the picture and the physics agree.
class WaterRipple {
  WaterRipple({required this.position, required this.strength});

  final Vector2 position;

  /// 0..1, scaled from the blast that produced it.
  final double strength;
  double age = 0;

  /// Meters from the impact point.
  double get radius => age * Tuning.waterRippleSpeed;

  /// Amplitude left, 1 at birth and 0 at the end of its life.
  double get fade {
    final t = (age / Tuning.waterRippleLife).clamp(0.0, 1.0);
    return math.pow(1 - t, 1.5).toDouble();
  }

  bool get finished => age >= Tuning.waterRippleLife;
}

/// The rings currently on the water. Capped at [max] because the shader takes
/// a fixed number of uniforms; the oldest one makes way for a new blast.
class WaterRipples {
  static const int max = 3;

  final List<WaterRipple> active = [];

  void add(Vector2 position, double strength) {
    if (active.length >= max) {
      active.removeAt(0);
    }
    active.add(WaterRipple(position: position.clone(), strength: strength));
  }

  void update(double dt) {
    if (active.isEmpty) {
      return;
    }
    for (final ripple in active) {
      ripple.age += dt;
    }
    active.removeWhere((r) => r.finished);
  }

  void clear() => active.clear();

  /// The i-th ring, or null when fewer than [i] are alive.
  WaterRipple? at(int i) => i < active.length ? active[i] : null;
}
