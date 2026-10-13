import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/painting.dart' show TextStyle, FontWeight;

import '../puff_game.dart';
import '../sim/heat.dart';
import '../tuning.dart';

/// Minimal neon HUD in viewport (screen) coordinates.
class Hud extends PositionComponent with HasGameReference<PuffGame> {
  Hud() : super(priority: 100);

  late final TextComponent _score;
  late final TextComponent _multiplier;
  late final TextComponent _status;
  late final TextComponent _track;
  late final TextComponent _center;

  final _barBg = Paint()..style = PaintingStyle.fill;
  final _bar = Paint()..style = PaintingStyle.fill;

  final Map<int, TextPaint> _paintCache = {};

  /// The heat tier last announced, and how long its name stays up.
  int _tier = 0;
  double _tierToast = 0;

  /// Text renderers are cached per (color, size) so palette switches work
  /// without allocating a TextPaint every frame.
  TextPaint _paint(Color color, double size, {FontWeight weight = FontWeight.w600}) {
    final key = Object.hash(color.toARGB32(), size, weight);
    return _paintCache.putIfAbsent(
      key,
      () => TextPaint(
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: weight,
          fontFamily: 'monospace',
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    final p = game.palette;
    _score = TextComponent(
      text: '0',
      textRenderer: _paint(p.primary, 30),
      anchor: Anchor.topCenter,
    );
    _multiplier = TextComponent(
      text: '',
      textRenderer: _paint(p.accent, 16),
      anchor: Anchor.topCenter,
    );
    _status = TextComponent(
      text: '',
      textRenderer: _paint(p.secondary, 13),
      anchor: Anchor.topLeft,
    );
    _center = TextComponent(
      text: '',
      textRenderer: _paint(p.glow, 22),
      anchor: Anchor.center,
    );
    _track = TextComponent(
      text: '',
      textRenderer: _paint(p.secondary, 12),
      anchor: Anchor.topCenter,
    );
    addAll([_score, _multiplier, _status, _track, _center]);
    _layout(game.size);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) {
      _layout(size);
    }
  }

  void _layout(Vector2 size) {
    final top = game.safeTop + 12;
    _score.position = Vector2(size.x / 2, top);
    _multiplier.position = Vector2(size.x / 2, top + 38);
    _status.position = Vector2(16, top);
    _track.position = Vector2(size.x / 2, top + 62);
    _center.position = Vector2(size.x / 2, size.y * 0.42);
  }

  @override
  void update(double dt) {
    final p = game.palette;
    final s = game.score;
    _score.text = '${s.score}';
    _score.textRenderer = _paint(p.primary, 30);
    _multiplier.text = s.combo > 0 && game.isPlaying
        ? 'x${s.multiplier.toStringAsFixed(2)}  combo ${s.combo}'
        : '';
    _multiplier.textRenderer = _paint(p.accent, 16);
    _status.text = Tuning.loseRule == LoseRule.core
        ? game.environment.name.toUpperCase()
        : '${game.environment.name.toUpperCase()}  escaped ${game.escapes}/${Tuning.maxEscapes}';
    _status.textRenderer = _paint(p.secondary, 13);
    // Opacity in a few steps, so the fade does not fill the paint cache.
    final jukebox = game.jukebox;
    final alpha = (jukebox.toastOpacity * 6).round() / 6;
    _track.text = alpha > 0 ? jukebox.toastText : '';
    _track.textRenderer = _paint(p.secondary.withValues(alpha: alpha), 12);
    // Announce a new heat tier; the first one arrives quietly.
    final tier = game.isPlaying ? game.tier : 0;
    if (tier > _tier && tier > 1) {
      _tierToast = Tuning.tierToastSeconds;
    }
    _tier = tier;
    _tierToast = game.isPlaying ? (_tierToast - dt).clamp(0.0, double.infinity) : 0;
    final tierAlpha = ((_tierToast / 0.4).clamp(0.0, 1.0) * 6).round() / 6;
    _center.text = tierAlpha > 0 ? HeatCurve.tierNames[tier] : '';
    _center.textRenderer = _paint(
      (tier >= 4 ? p.hazard : p.glow).withValues(alpha: tierAlpha),
      22,
    );
  }

  @override
  void render(Canvas canvas) {
    final cloud = game.cloud;
    if (cloud == null) {
      return;
    }
    // Charge bar at the bottom.
    final size = game.size;
    final w = size.x * 0.5;
    final h = 6.0;
    final x = (size.x - w) / 2;
    final y = size.y - game.safeBottom - 24;
    _barBg.color = game.palette.bgAlt;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), const Radius.circular(3)),
      _barBg,
    );
    final op = cloud.charge.overpressureProgress;
    _bar.color = Color.lerp(
      game.palette.primary,
      game.palette.hazard,
      op > 0.6 ? (op - 0.6) / 0.4 : 0,
    )!;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w * cloud.energy, h),
        const Radius.circular(3),
      ),
      _bar,
    );
  }
}
