import 'package:flutter_test/flutter_test.dart';
import 'package:puff/game/palette.dart';
import 'package:puff/game/sim/season.dart';

void main() {
  test('holiday is on from 1 December to 6 January, every year', () {
    const h = Season.holiday;
    expect(h.activeAt(DateTime.utc(2026, 11, 30, 23)), isFalse);
    expect(h.activeAt(DateTime.utc(2026, 12, 1)), isTrue);
    expect(h.activeAt(DateTime.utc(2026, 12, 31)), isTrue);
    expect(h.activeAt(DateTime.utc(2027, 1, 6, 23)), isTrue);
    expect(h.activeAt(DateTime.utc(2027, 1, 7)), isFalse);
    expect(h.activeAt(DateTime.utc(2030, 12, 24)), isTrue);
  });

  test('no config: built-in seasons by date', () {
    expect(RemoteConfig.empty.palettesAt(DateTime.utc(2026, 12, 24)), [Palette.holiday]);
    expect(RemoteConfig.empty.palettesAt(DateTime.utc(2026, 7, 1)), isEmpty);
    expect(RemoteConfig.empty.weekly, isTrue);
  });

  test('remote config can switch off a built-in season and the weekly', () {
    final c = RemoteConfig.parse('{"weekly": false, "seasons": [{"name": "Holiday", "enabled": false}]}');
    expect(c.weekly, isFalse);
    expect(c.palettesAt(DateTime.utc(2026, 12, 24)), isEmpty);
  });

  test('remote config adds a dated palette', () {
    final c = RemoteConfig.parse('''
      {"seasons": [{"name": "Spring", "from": "2027-03-20", "until": "2027-04-10",
        "colors": {"bg": "#05110A", "bgAlt": "#0B2416", "primary": "#7CFFB2",
                   "secondary": "#FF8AD8", "accent": "#FFF27A", "hazard": "#FF5A3C",
                   "glow": "#C9FFE0"}}]}''');
    final spring = c.palettesAt(DateTime.utc(2027, 3, 25));
    expect(spring.single.name, 'Spring');
    expect(spring.single.primary.toARGB32(), 0xFF7CFFB2);
    expect(c.palettesAt(DateTime.utc(2027, 4, 10)), isEmpty);
  });

  test('malformed input never throws', () {
    for (final body in ['', 'nope', '[]', '{"seasons": 3}', '{"seasons": [{"name": "X"}]}',
        '{"seasons": [{"name": "Y", "from": "2027-01-01", "until": "2027-02-01", "colors": {"bg": "red"}}]}']) {
      final c = RemoteConfig.parse(body);
      expect(c.palettesAt(DateTime.utc(2027, 1, 15)), isEmpty, reason: body);
    }
  });

  test('an out-of-season palette falls back to Cyberpunk', () {
    Palette.inSeason = const [];
    expect(Palette.byName('Holiday'), Palette.cyberpunk);
    Palette.inSeason = const [Palette.holiday];
    expect(Palette.byName('Holiday'), Palette.holiday);
    expect(Palette.available.last, Palette.holiday);
    Palette.inSeason = const [];
  });
}
