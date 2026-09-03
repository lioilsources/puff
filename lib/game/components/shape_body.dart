import 'dart:math' as math;
import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart' hide ShapeSpec;

import '../palette.dart';
import '../puff_game.dart';
import '../sim/blast.dart';
import '../sim/shapes.dart';
import '../tuning.dart';

/// A physical neon shape. Rendering is a stroke outline in body-local space.
class ShapeBody extends BodyComponent<PuffGame>
    with ContactCallbacks
    implements BlastBody {
  ShapeBody({
    required this.spec,
    required Vector2 position,
    required Vector2 velocity,
    double angle = 0,
    double angularVelocity = 0,
    this.generation = 0,
  }) : _initialPosition = position.clone(),
       _initialVelocity = velocity.clone(),
       _initialAngle = angle,
       _initialAngularVelocity = angularVelocity,
       super(renderBody: false, priority: 0);

  final ShapeSpec spec;

  /// Fracture depth: 0 for spawned shapes, +1 per split.
  final int generation;

  final Vector2 _initialPosition;
  final Vector2 _initialVelocity;
  final double _initialAngle;
  final double _initialAngularVelocity;

  late final List<Vector2> vertices = spec.vertices();
  late final Path _outline = _buildOutline();

  /// 1 right after a hit, decays to 0. Drives a brief flash.
  double hitFlash = 0;

  /// Set by the detonator when the received impulse exceeds the threshold.
  Vector2? pendingFracture;

  final _stroke = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = Tuning.strokeWidth
    ..strokeJoin = StrokeJoin.round;
  final _fill = Paint()..style = PaintingStyle.fill;
  final _inner = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = Tuning.strokeWidth * 0.6;

  PaletteRole get role => switch (spec.kind) {
    ShapeKind.tri => PaletteRole.primary,
    ShapeKind.square => PaletteRole.secondary,
    ShapeKind.poly => PaletteRole.accent,
    ShapeKind.circle => PaletteRole.glow,
  };

  Color get color => game.palette.byRole(role);

  @override
  Body createBody() {
    final env = game.environment;
    final def = BodyDef(
      type: BodyType.dynamic,
      position: _initialPosition,
      rotation: Rot.fromAngle(_initialAngle),
      linearVelocity: _initialVelocity,
      angularVelocity: _initialAngularVelocity,
      linearDamping: env.linearDamping,
      angularDamping: env.angularDamping,
      userData: this,
    );
    final body = world.createBody(def);
    final shapeDef = ShapeDef(
      density: spec.density,
      material: SurfaceMaterial(
        friction: spec.friction,
        restitution: spec.restitution,
      ),
      userData: this,
      enableContactEvents: true,
      enableSensorEvents: true,
    );
    final geometry = spec.kind == ShapeKind.circle
        ? Circle(radius: spec.size)
        : Polygon(vertices);
    body.createShape(geometry, shapeDef);
    return body;
  }

  Path _buildOutline() {
    final path = Path();
    if (spec.kind == ShapeKind.circle) {
      path.addOval(Rect.fromCircle(center: Offset.zero, radius: spec.size));
      return path;
    }
    path.addPolygon(
      vertices.map((v) => Offset(v.x, v.y)).toList(growable: false),
      true,
    );
    return path;
  }

  @override
  void onMount() {
    super.onMount();
    game.registerShape(this);
  }

  @override
  void onRemove() {
    game.unregisterShape(this);
    super.onRemove();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (hitFlash > 0) {
      hitFlash = math.max(0, hitFlash - dt * 4);
    }
    final p = body.position;
    final half = game.worldSize / 2;
    final m = Tuning.despawnMargin;
    if (p.x < -half.x - m || p.x > half.x + m || p.y < -half.y - m) {
      removeFromParent();
    } else if (p.y > half.y + m) {
      game.onShapeLeftBottom(this);
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final c = color;
    _fill.color = c.withValues(alpha: 0.10 + 0.5 * hitFlash);
    _stroke.color = Color.lerp(c, game.palette.glow, hitFlash)!;
    canvas.drawPath(_outline, _fill);
    canvas.drawPath(_outline, _stroke);
    if (spec.material == ShapeMaterial.metal) {
      // Metal: a second, inset outline.
      _inner.color = c.withValues(alpha: 0.7);
      canvas.save();
      canvas.scale(0.62);
      canvas.drawPath(_outline, _inner);
      canvas.restore();
    }
  }

  // ---- Contacts ------------------------------------------------------------

  @override
  void beginContact(Object other, Contact contact) {
    if (other is ShapeBody) {
      final relative = (body.linearVelocity - other.body.linearVelocity).length;
      if (relative > 0.8) {
        hitFlash = 1;
        game.onShapeHit(this, other, relative);
      }
    }
  }

  // ---- BlastBody -----------------------------------------------------------

  @override
  Vector2 get blastPosition => body.position;

  @override
  double get blastMass => body.mass;

  @override
  void applyBlastImpulse(Vector2 impulse, double angularImpulse) {
    body.applyLinearImpulse(impulse);
    body.applyAngularImpulse(angularImpulse);
  }
}
