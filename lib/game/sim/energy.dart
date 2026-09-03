import 'dart:math' as math;

/// Maps hold time (seconds) to normalized energy in [0, 1].
///
/// Kept engine-agnostic (no Flutter `Curve`) so the sim can be unit tested
/// with plain `package:test`.
abstract class EnergyCurve {
  const EnergyCurve();

  double transform(double t);
}

/// Ease-in for the first [easeInDuration] seconds, near-linear in the middle,
/// asymptotic toward 1.0 as t approaches [tOverpressure].
class PuffEnergyCurve extends EnergyCurve {
  const PuffEnergyCurve({
    required this.tOverpressure,
    this.easeInDuration = 0.3,
    this.approachPower = 1.7,
  });

  final double tOverpressure;
  final double easeInDuration;

  /// >1 makes the curve concave: fast early gains that flatten near the top.
  final double approachPower;

  @override
  double transform(double t) {
    if (t <= 0) {
      return 0;
    }
    final s = (t / tOverpressure).clamp(0.0, 1.0);
    final base = 1 - math.pow(1 - s, approachPower);
    final u = (t / easeInDuration).clamp(0.0, 1.0);
    final ramp = u * u * (3 - 2 * u);
    return (base * ramp).clamp(0.0, 1.0);
  }
}

/// Mutable charge state of one held-down cloud.
class Charge {
  Charge({
    required this.curve,
    required this.tOverpressure,
    required this.overpressurePenalty,
    required this.drainRate,
  });

  final EnergyCurve curve;
  final double tOverpressure;
  final double overpressurePenalty;

  /// Seconds of charge lost per second per overlapping body.
  final double drainRate;

  /// Raw wall-clock time the finger has been down.
  double holdTime = 0;

  /// Seconds of charge lost to bodies sitting inside the cloud.
  double drained = 0;

  /// Whether the last tick removed energy (drives the jitter visual).
  bool drainedThisTick = false;

  double get effectiveTime => math.max(0, holdTime - drained);

  double get energy => curve.transform(effectiveTime);

  /// 0..1 fraction of the way to self-detonation.
  double get overpressureProgress => (holdTime / tOverpressure).clamp(0.0, 1.0);

  bool get overpressured => holdTime >= tOverpressure;

  void tick(double dt, {int drainingBodies = 0}) {
    holdTime += dt;
    final loss = drainRate * dt * drainingBodies;
    drained += loss;
    drainedThisTick = loss > 0;
  }

  /// Energy delivered on release; an overpressured cloud fizzles.
  double releaseEnergy() =>
      overpressured ? energy * overpressurePenalty : energy;
}
