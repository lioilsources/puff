import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../puff_game.dart';
import '../sim/explosion_event.dart';
import '../sim/fx_event.dart';

/// Haptics scaled to blast energy. Fracture ticks are throttled.
class HapticsSystem extends Component with HasGameReference<PuffGame> {
  bool enabled = true;
  double _fractureCooldown = 0;

  @override
  Future<void> onLoad() async {
    game.explosionListeners.add(onExplosion);
    game.fractureListeners.add(onFracture);
  }

  @override
  void onRemove() {
    game.explosionListeners.remove(onExplosion);
    game.fractureListeners.remove(onFracture);
    super.onRemove();
  }

  @override
  void update(double dt) {
    if (_fractureCooldown > 0) {
      _fractureCooldown -= dt;
    }
  }

  void onExplosion(ExplosionEvent e) {
    if (!enabled) {
      return;
    }
    if (e.kind == ExplosionKind.fizzle) {
      HapticFeedback.selectionClick();
      return;
    }
    if (e.energy < 0.3) {
      HapticFeedback.lightImpact();
    } else if (e.energy < 0.7) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void onFracture(FractureEvent f) {
    if (!enabled || _fractureCooldown > 0) {
      return;
    }
    _fractureCooldown = 0.08;
    HapticFeedback.lightImpact();
  }

  void onCoreHit() {
    if (enabled) {
      HapticFeedback.heavyImpact();
    }
  }
}
