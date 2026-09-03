import 'package:vector_math/vector_math.dart';

enum TouchPhase { idle, charging, released }

/// Single-touch hold/drag/release state machine. Pure Dart; the game feeds
/// it pointer events and it calls back with positions in world space.
class TouchController {
  TouchController({
    required this.onDown,
    required this.onMove,
    required this.onUp,
    required this.onCancel,
  });

  final void Function(Vector2 position) onDown;
  final void Function(Vector2 position) onMove;
  final void Function() onUp;
  final void Function() onCancel;

  TouchPhase phase = TouchPhase.idle;
  int? _activePointer;

  bool get isCharging => phase == TouchPhase.charging;

  /// Returns true if this pointer became the active one.
  bool pointerDown(int pointerId, Vector2 position) {
    if (_activePointer != null) {
      return false; // second finger is ignored
    }
    _activePointer = pointerId;
    phase = TouchPhase.charging;
    onDown(position);
    return true;
  }

  void pointerMove(int pointerId, Vector2 position) {
    if (pointerId != _activePointer) {
      return;
    }
    onMove(position);
  }

  void pointerUp(int pointerId) {
    if (pointerId != _activePointer) {
      return;
    }
    phase = TouchPhase.released;
    _activePointer = null;
    onUp();
    phase = TouchPhase.idle;
  }

  void pointerCancel(int pointerId) {
    if (pointerId != _activePointer) {
      return;
    }
    phase = TouchPhase.released;
    _activePointer = null;
    onCancel();
    phase = TouchPhase.idle;
  }

  /// Force back to idle (e.g. game over while holding).
  void reset() {
    _activePointer = null;
    phase = TouchPhase.idle;
  }
}
