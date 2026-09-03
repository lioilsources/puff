import 'package:puff/game/sim/energy.dart';
import 'package:test/test.dart';

void main() {
  const curve = PuffEnergyCurve(tOverpressure: 3.2, easeInDuration: 0.3);

  test('energy curve is monotonic non-decreasing', () {
    var prev = -1.0;
    for (var i = 0; i <= 400; i++) {
      final t = i / 100;
      final e = curve.transform(t);
      expect(e, greaterThanOrEqualTo(prev), reason: 't=$t');
      expect(e, inInclusiveRange(0, 1));
      prev = e;
    }
  });

  test('energy curve starts at 0 and reaches 1 at overpressure', () {
    expect(curve.transform(0), 0);
    expect(curve.transform(-1), 0);
    expect(curve.transform(3.2), closeTo(1, 1e-9));
    expect(curve.transform(10), closeTo(1, 1e-9));
  });

  test('ease-in: early slope is smaller than mid slope', () {
    final early = curve.transform(0.1) - curve.transform(0.0);
    final mid = curve.transform(0.9) - curve.transform(0.8);
    expect(early, lessThan(mid));
  });

  test('asymptotic: late slope is smaller than mid slope', () {
    final mid = curve.transform(1.5) - curve.transform(1.4);
    final late = curve.transform(3.1) - curve.transform(3.0);
    expect(late, lessThan(mid));
  });

  group('Charge', () {
    Charge make() => Charge(
      curve: curve,
      tOverpressure: 3.2,
      overpressurePenalty: 0.5,
      drainRate: 0.5,
    );

    test('drain lowers energy', () {
      final a = make();
      final b = make();
      for (var i = 0; i < 60; i++) {
        a.tick(1 / 60);
        b.tick(1 / 60, drainingBodies: 2);
      }
      expect(b.energy, lessThan(a.energy));
      expect(b.drainedThisTick, isTrue);
      expect(a.drainedThisTick, isFalse);
    });

    test('overpressure applies penalty on release', () {
      final c = make();
      c.tick(3.3);
      expect(c.overpressured, isTrue);
      expect(c.releaseEnergy(), closeTo(c.energy * 0.5, 1e-9));
    });

    test('effective time never negative', () {
      final c = make();
      c.tick(0.1, drainingBodies: 50);
      expect(c.effectiveTime, 0);
      expect(c.energy, 0);
    });
  });
}
