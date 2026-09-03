import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

/// Trauma-based screen shake: shake = trauma^2, trauma decays linearly.
/// Also carries a short zoom-out pulse for big blasts.
class ScreenShake {
  ScreenShake(this.random, {
    this.decay = 1.4,
    this.maxOffset = 0.35,
    this.maxAngle = 0.03,
    this.frequency = 28,
  });

  final math.Random random;
  final double decay;

  /// Meters.
  final double maxOffset;

  /// Radians.
  final double maxAngle;
  final double frequency;

  double trauma = 0;
  double _time = 0;
  double _zoomPulse = 0;

  final offset = Vector2.zero();
  double angle = 0;

  /// Multiply the camera zoom by this (1 = no pulse).
  double get zoom => 1 - _zoomPulse;

  void addTrauma(double amount) {
    trauma = (trauma + amount).clamp(0.0, 1.0);
  }

  void addZoomPulse(double amount) {
    _zoomPulse = math.max(_zoomPulse, amount.clamp(0.0, 0.2));
  }

  void update(double dt) {
    _time += dt;
    trauma = math.max(0, trauma - decay * dt);
    _zoomPulse = math.max(0, _zoomPulse - dt * 0.6);
    final shake = trauma * trauma;
    if (shake <= 0) {
      offset.setZero();
      angle = 0;
      return;
    }
    // Cheap band-limited noise: two sines with random phases per call.
    final t = _time * frequency;
    offset.setValues(
      maxOffset * shake * (math.sin(t * 1.0 + 0.3) * 0.6 + (random.nextDouble() * 2 - 1) * 0.4),
      maxOffset * shake * (math.sin(t * 1.3 + 2.1) * 0.6 + (random.nextDouble() * 2 - 1) * 0.4),
    );
    angle = maxAngle * shake * (math.sin(t * 0.7) * 0.5 + (random.nextDouble() * 2 - 1) * 0.5);
  }
}
