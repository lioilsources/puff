import 'package:puff/app/deep_link.dart';
import 'package:puff/app/review_policy.dart';
import 'package:test/test.dart';

DeepLink parse(String s) => DeepLink.parse(Uri.parse(s));

void main() {
  test('play', () {
    expect(parse('puff://play'), isA<StartRun>());
    expect(parse('puff:///play'), isA<StartRun>());
    expect(parse('puff://PLAY'), isA<StartRun>());
  });

  test('palette', () {
    final link = parse('puff://palette/Vaporwave');
    expect(link, isA<SelectPalette>());
    expect((link as SelectPalette).name, 'vaporwave');
  });

  test('events', () {
    expect(parse('puff://event/weekly'), isA<StartWeekly>());
    final e = parse('puff://event/holiday-2026');
    expect((e as OpenEvent).id, 'holiday-2026');
  });

  test('anything else opens the menu', () {
    for (final s in ['puff://', 'puff://nope', 'puff://palette', 'puff://play/extra',
        'https://example.com/play', 'puff://event']) {
      expect(parse(s), isA<OpenMenu>(), reason: s);
    }
  });

  group('review policy', () {
    const p = ReviewPolicy();
    bool ask({int session = 3, String? last, bool best = true, bool x4 = false}) => p.shouldAsk(
      appVersion: '1.3.0',
      lastAskedVersion: last,
      session: session,
      newBest: best,
      comboX4: x4,
    );

    test('after a best or an x4 combo', () {
      expect(ask(), isTrue);
      expect(ask(best: false, x4: true), isTrue);
      expect(ask(best: false), isFalse);
    });

    test('never in the first session', () => expect(ask(session: 1), isFalse));

    test('once per version', () {
      expect(ask(last: '1.3.0'), isFalse);
      expect(ask(last: '1.2.3'), isTrue);
    });
  });
}
