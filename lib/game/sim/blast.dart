import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

/// Pure impulse math for a pressure blast. No physics engine involved.
class BlastParams {
  const BlastParams({
    required this.roeMin,
    required this.roeMax,
    required this.rMin,
    required this.falloffPower,
    required this.impulseScale,
    required this.torqueScale,
  });

  /// Radius of effect at energy 0 and 1.
  final double roeMin;
  final double roeMax;

  /// Distance clamp so bodies at the center don't get infinite impulse.
  final double rMin;
  final double falloffPower;
  final double impulseScale;
  final double torqueScale;

  double radiusOfEffect(double energy) =>
      roeMin + (roeMax - roeMin) * energy.clamp(0.0, 1.0);
}

class BlastResult {
  const BlastResult({
    required this.impulse,
    required this.angularImpulse,
    required this.falloff,
  });

  final Vector2 impulse;
  final double angularImpulse;
  final double falloff;

  double get magnitude => impulse.length;
}

/// Returns null when [bodyPos] is outside the radius of effect.
///
/// ```
/// d = body.pos - origin
/// dist = max(|d|, rMin)
/// falloff = (1 - dist / radiusOfEffect)^falloffPower
/// impulse = normalize(d) * energy * impulseScale * falloff * blastMultiplier
/// ```
BlastResult? computeBlast({
  required BlastParams params,
  required Vector2 origin,
  required Vector2 bodyPos,
  required double energy,
  required double blastMultiplier,
  required double randomSign,
  double? radiusOverride,
  double directionSign = 1,
}) {
  final radius = radiusOverride ?? params.radiusOfEffect(energy);
  final d = bodyPos - origin;
  final rawDist = d.length;
  if (rawDist > radius) {
    return null;
  }
  final dist = math.max(rawDist, params.rMin);
  final falloff = math.pow(1 - dist / radius, params.falloffPower).toDouble();
  final dir = rawDist < 1e-6 ? Vector2(0, -1) : d / rawDist;
  final impulse =
      dir * (energy * params.impulseScale * falloff * blastMultiplier * directionSign);
  final angular = params.torqueScale * energy * falloff * randomSign;
  return BlastResult(impulse: impulse, angularImpulse: angular, falloff: falloff);
}

/// What a detonation needs from a physical body. Implemented by the Flame
/// component so the sim never imports the engine.
abstract interface class BlastBody {
  Vector2 get blastPosition;
  double get blastMass;
  void applyBlastImpulse(Vector2 impulse, double angularImpulse);
}
