import 'dart:math' as math;

import 'package:flame/components.dart';

import '../puff_game.dart';

/// Scripted touches for screenshots and soak testing
/// (`--dart-define=PUFF_DEMO=true`). Drives the same pointer entry points
/// the touch layer uses.
class DemoDriver extends Component with HasGameReference<PuffGame> {
  DemoDriver(this.random);

  final math.Random random;
  double _timer = 1.2;
  bool _holding = false;
  double _holdLeft = 0;
  final _pos = Vector2.zero();
  final _drift = Vector2.zero();
  static const _pointer = 999;

  @override
  void update(double dt) {
    if (!game.isPlaying) {
      _holding = false;
      _timer = 1.0;
      return;
    }
    _timer -= dt;
    if (_holding) {
      _holdLeft -= dt;
      _pos.add(_drift * dt);
      game.onPointerMove(_pointer, _pos);
      if (_holdLeft <= 0) {
        _holding = false;
        game.onPointerUp(_pointer);
        _timer = 0.6 + random.nextDouble() * 1.2;
      }
      return;
    }
    if (_timer <= 0) {
      final size = game.size;
      _pos.setValues(
        size.x * (0.2 + random.nextDouble() * 0.6),
        size.y * (0.25 + random.nextDouble() * 0.5),
      );
      _drift.setValues(
        (random.nextDouble() - 0.5) * 60,
        (random.nextDouble() - 0.5) * 60,
      );
      _holdLeft = 0.6 + random.nextDouble() * 2.2;
      _holding = true;
      game.onPointerDown(_pointer, _pos);
    }
  }
}
