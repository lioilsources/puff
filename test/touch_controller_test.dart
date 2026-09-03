import 'package:puff/game/input/touch_controller.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  test('single touch: down/move/up sequence', () {
    final log = <String>[];
    final c = TouchController(
      onDown: (p) => log.add('down ${p.x}'),
      onMove: (p) => log.add('move ${p.x}'),
      onUp: () => log.add('up'),
      onCancel: () => log.add('cancel'),
    );
    expect(c.pointerDown(1, Vector2(1, 0)), isTrue);
    expect(c.isCharging, isTrue);
    c.pointerMove(1, Vector2(2, 0));
    c.pointerUp(1);
    expect(c.phase, TouchPhase.idle);
    expect(log, ['down 1.0', 'move 2.0', 'up']);
  });

  test('second finger is ignored entirely', () {
    final log = <String>[];
    final c = TouchController(
      onDown: (p) => log.add('down'),
      onMove: (p) => log.add('move'),
      onUp: () => log.add('up'),
      onCancel: () => log.add('cancel'),
    );
    c.pointerDown(1, Vector2.zero());
    expect(c.pointerDown(2, Vector2.zero()), isFalse);
    c.pointerMove(2, Vector2.zero());
    c.pointerUp(2);
    expect(log, ['down']);
    c.pointerUp(1);
    expect(log, ['down', 'up']);
  });

  test('cancel routes to onCancel', () {
    final log = <String>[];
    final c = TouchController(
      onDown: (p) => log.add('down'),
      onMove: (p) => log.add('move'),
      onUp: () => log.add('up'),
      onCancel: () => log.add('cancel'),
    );
    c.pointerDown(7, Vector2.zero());
    c.pointerCancel(7);
    expect(log, ['down', 'cancel']);
    expect(c.phase, TouchPhase.idle);
  });
}
