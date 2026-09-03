import 'package:vector_math/vector_math.dart';

import 'shapes.dart';

/// A shape broke apart. Consumed by FX and audio.
class FractureEvent {
  const FractureEvent({
    required this.position,
    required this.kind,
    required this.material,
    required this.fragmentCount,
    required this.dust,
    required this.velocity,
  });

  final Vector2 position;
  final ShapeKind kind;
  final ShapeMaterial material;
  final int fragmentCount;

  /// World positions of pieces too small to be bodies.
  final List<Vector2> dust;

  /// Parent velocity at the time of the split.
  final Vector2 velocity;
}

/// An electric arc between consecutive points. Consumed by FX and audio.
class ArcEvent {
  const ArcEvent({required this.points, required this.energy});

  final List<Vector2> points;
  final double energy;
}
