import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../fx/shaders.dart';
import '../puff_game.dart';
import '../sim/environment.dart';

/// Per-environment shader background, drawn in world space under everything
/// (so it is part of the post-processed scene).
class BackgroundLayer extends Component with HasGameReference<PuffGame> {
  BackgroundLayer() : super(priority: -100);

  FragmentShader? _shader;
  double time = 0;

  /// Plasma flash, decays quickly.
  double flash = 0;

  final _paint = Paint();

  @override
  void onMount() {
    super.onMount();
    _shader = game.shaders?.background.fragmentShader();
  }

  @override
  void update(double dt) {
    time += dt;
    flash = math.max(0, flash - dt * 4);
  }

  @override
  void render(Canvas canvas) {
    final rect = game.camera.visibleWorldRect.inflate(1.0);
    final shader = _shader;
    final p = game.palette;
    if (shader == null) {
      _paint.shader = null;
      _paint.color = p.bg;
      canvas.drawRect(rect, _paint);
      return;
    }
    final envIndex = switch (game.environment.kind) {
      EnvironmentKind.vacuum => 0.0,
      EnvironmentKind.air => 1.0,
      EnvironmentKind.water => 2.0,
      EnvironmentKind.plasma => 3.0,
    };
    UniformWriter(shader)
      ..v2(rect.left, rect.top)
      ..v2(rect.width, rect.height)
      ..f(time)
      ..f(envIndex)
      ..f(flash)
      ..color(p.bg)
      ..color(p.bgAlt)
      ..color(p.primary)
      ..color(p.secondary);
    _paint.shader = shader;
    canvas.drawRect(rect, _paint);
  }
}
