import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

enum EnvironmentKind { vacuum, air, water, plasma }

/// Ambient behavior that the physics layer implements (plasma arcs etc.).
class AmbientEffect {
  const AmbientEffect({required this.interval, required this.strength});

  /// Seconds between events.
  final double interval;
  final double strength;
}

class Environment {
  const Environment({
    required this.kind,
    required this.linearDamping,
    required this.angularDamping,
    required this.blastMultiplier,
    required this.gravityY,
    this.windAmplitude = 0,
    this.windPeriod = 6,
    this.ambient,
  });

  final EnvironmentKind kind;
  final double linearDamping;
  final double angularDamping;
  final double blastMultiplier;
  final double gravityY;

  /// Horizontal sinusoidal wind, m/s^2 applied as force per kg.
  final double windAmplitude;
  final double windPeriod;
  final AmbientEffect? ambient;

  String get name => switch (kind) {
    EnvironmentKind.vacuum => 'Vacuum',
    EnvironmentKind.air => 'Air',
    EnvironmentKind.water => 'Water',
    EnvironmentKind.plasma => 'Plasma',
  };

  Vector2 gravity() => Vector2(0, gravityY);

  /// Global wind vector at [time], in force per unit mass.
  Vector2 wind(double time) {
    if (windAmplitude == 0) {
      return Vector2.zero();
    }
    return Vector2(
      windAmplitude * math.sin(2 * math.pi * time / windPeriod),
      0,
    );
  }

  static const vacuum = Environment(
    kind: EnvironmentKind.vacuum,
    linearDamping: 0,
    angularDamping: 0,
    blastMultiplier: 1.4,
    gravityY: 0,
  );

  static const air = Environment(
    kind: EnvironmentKind.air,
    linearDamping: 0.4,
    angularDamping: 0.4,
    blastMultiplier: 1.0,
    gravityY: 1.2,
    windAmplitude: 0.6,
    windPeriod: 7,
  );

  static const water = Environment(
    kind: EnvironmentKind.water,
    linearDamping: 3.0,
    angularDamping: 2.0,
    blastMultiplier: 0.6,
    gravityY: 0.35,
  );

  static const plasma = Environment(
    kind: EnvironmentKind.plasma,
    linearDamping: 0.6,
    angularDamping: 0.3,
    blastMultiplier: 1.15,
    gravityY: 0,
    ambient: AmbientEffect(interval: 4.5, strength: 1.8),
  );

  static const presets = [vacuum, air, water, plasma];

  static Environment byKind(EnvironmentKind kind) =>
      presets.firstWhere((e) => e.kind == kind);
}
