import 'package:puff/game/sim/score.dart';
import 'package:test/test.dart';

void main() {
  ScoreModel make() => ScoreModel(
    pointsPerImpulse: 10,
    comboWindow: 1.0,
    comboStep: 0.25,
    maxMultiplier: 3,
    fractureBonus: 25,
  );

  test('impulse gives points scaled by multiplier', () {
    final s = make();
    expect(s.onImpulse(2), 20);
    expect(s.score, 20);
    expect(s.bodiesDisplaced, 1);
  });

  test('hits inside the window after a blast build a combo', () {
    final s = make();
    s.onBlast();
    s.update(0.3);
    s.onShapeHit();
    s.update(0.3);
    s.onShapeHit();
    expect(s.combo, 2);
    expect(s.multiplier, 1.5);
    expect(s.onImpulse(1), 15);
  });

  test('hits outside the window do not count', () {
    final s = make();
    s.onBlast();
    s.update(1.5);
    s.onShapeHit();
    expect(s.combo, 0);
  });

  test('combo decays after the window passes', () {
    final s = make();
    s.onBlast();
    s.onShapeHit();
    expect(s.combo, 1);
    s.update(1.1);
    expect(s.combo, 0);
    expect(s.bestCombo, 1);
  });

  test('multiplier is capped', () {
    final s = make();
    s.onBlast();
    for (var i = 0; i < 20; i++) {
      s.onShapeHit();
    }
    expect(s.multiplier, 3);
  });

  test('fracture bonus uses multiplier', () {
    final s = make();
    s.onBlast();
    s.onShapeHit();
    s.onFracture();
    expect(s.score, 31);
    expect(s.fractures, 1);
  });
}
