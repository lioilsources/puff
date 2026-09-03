import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';

import '../puff_game.dart';
import '../tuning.dart';

/// FPS, body count, particle count and the live tuning knobs that matter.
class DebugOverlay extends PositionComponent with HasGameReference<PuffGame> {
  DebugOverlay() : super(priority: 200);

  late final TextComponent _text;
  final List<double> _frames = [];
  double _accum = 0;

  @override
  Future<void> onLoad() async {
    _text = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: TextStyle(
          color: game.palette.glow.withValues(alpha: 0.85),
          fontSize: 11,
          fontFamily: 'monospace',
          height: 1.25,
        ),
      ),
      anchor: Anchor.topLeft,
    );
    add(_text);
  }

  @override
  void update(double dt) {
    _frames.add(dt);
    if (_frames.length > 60) {
      _frames.removeAt(0);
    }
    _accum += dt;
    if (_accum < 0.25) {
      return;
    }
    _accum = 0;
    final avg = _frames.isEmpty
        ? 0.0
        : _frames.reduce((a, b) => a + b) / _frames.length;
    final fps = avg > 0 ? (1 / avg).round() : 0;
    final cloud = game.cloud;
    _text.position = Vector2(12, game.safeTop + 40);
    _text.text = [
      'fps $fps  bodies ${game.shapes.length}/${Tuning.maxBodies}  particles ${game.fx.particles.count}',
      'env ${game.environment.name}  mod ${game.modifiers.spec.name}  q ${game.quality.name}',
      'wells ${game.modifiers.wells.length}  shock ${game.postProcess?.shockwaves.length ?? 0}  shaders ${game.shaders != null}',
      if (cloud != null)
        'cloud e ${cloud.energy.toStringAsFixed(2)} r ${cloud.radius.toStringAsFixed(2)} '
            'op ${cloud.charge.overpressureProgress.toStringAsFixed(2)} inside ${cloud.inside.length}',
      'blast roe ${Tuning.blast.roeMin}-${Tuning.blast.roeMax} k ${Tuning.blast.impulseScale} '
          'fall ${Tuning.blast.falloffPower}  break ${Tuning.breakThreshold}',
      'cloud r ${Tuning.cloudRMin}-${Tuning.cloudRMax} tOP ${Tuning.tOverpressure} '
          'drain ${Tuning.drainRate} lag ${Tuning.lagBase}+${Tuning.lagPerRadius}r',
      'spawn ${game.spawner.interval.toStringAsFixed(2)}s  t ${game.elapsed.toStringAsFixed(0)}s',
    ].join('\n');
  }

  @override
  void render(Canvas canvas) {}
}
