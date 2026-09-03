import 'package:vector_math/vector_math.dart';

enum ExplosionKind { pressure, fizzle, implosion, magnet, gravityWell, chainSpark }

/// Emitted by a detonation; consumed by FX, audio, haptics and scoring.
class ExplosionEvent {
  const ExplosionEvent({
    required this.position,
    required this.energy,
    required this.kind,
    required this.radius,
    this.bodiesHit = 0,
    this.totalImpulse = 0,
  });

  final Vector2 position;

  /// Normalized 0..1.
  final double energy;
  final ExplosionKind kind;

  /// Radius of effect in meters.
  final double radius;
  final int bodiesHit;
  final double totalImpulse;

  ExplosionEvent copyWith({int? bodiesHit, double? totalImpulse}) =>
      ExplosionEvent(
        position: position,
        energy: energy,
        kind: kind,
        radius: radius,
        bodiesHit: bodiesHit ?? this.bodiesHit,
        totalImpulse: totalImpulse ?? this.totalImpulse,
      );
}
