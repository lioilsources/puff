import 'dart:convert';
import 'dart:ui';

import '../palette.dart';

/// A palette offered only for part of the year.
///
/// Built-in seasons recur every year on a month/day window, so the December
/// palette needs no update. The remote config can add more, move a window,
/// or switch one off; it is optional, and when it cannot be read the built-in
/// windows apply.
class Season {
  const Season({
    required this.palette,
    this.fromMonthDay,
    this.untilMonthDay,
    this.from,
    this.until,
    this.enabled = true,
  });

  final Palette palette;

  /// Yearly window as (month, day), [from inclusive, until exclusive). May
  /// wrap over New Year.
  final (int, int)? fromMonthDay;
  final (int, int)? untilMonthDay;

  /// One-off window in UTC, used by remote entries.
  final DateTime? from;
  final DateTime? until;
  final bool enabled;

  bool activeAt(DateTime now) {
    if (!enabled) {
      return false;
    }
    final utc = now.toUtc();
    if (from != null && until != null) {
      return !utc.isBefore(from!) && utc.isBefore(until!);
    }
    final a = fromMonthDay, b = untilMonthDay;
    if (a == null || b == null) {
      return false;
    }
    final today = utc.month * 100 + utc.day;
    final start = a.$1 * 100 + a.$2;
    final end = b.$1 * 100 + b.$2;
    return start <= end
        ? today >= start && today < end
        : today >= start || today < end;
  }

  static const holiday = Season(
    palette: Palette.holiday,
    fromMonthDay: (12, 1),
    untilMonthDay: (1, 7),
  );

  static const builtIns = [holiday];
}

/// The optional JSON at [RemoteConfig.url]:
///
/// ```json
/// {
///   "weekly": true,
///   "seasons": [
///     {"name": "Holiday", "enabled": true},
///     {"name": "Spring", "from": "2027-03-20", "until": "2027-04-10",
///      "colors": {"bg": "#05110A", "bgAlt": "#0B2416", "primary": "#7CFFB2",
///                 "secondary": "#FF8AD8", "accent": "#FFF27A",
///                 "hazard": "#FF5A3C", "glow": "#C9FFE0"}}
///   ]
/// }
/// ```
///
/// An entry named like a built-in season changes that season (switches it
/// off, or moves it to fixed dates); any other name needs all seven colours.
class RemoteConfig {
  const RemoteConfig({this.weekly = true, this.seasons = const []});

  static const url = 'https://olin.now/apps/puff/config.json';

  /// False hides the weekly challenge, e.g. while its leaderboard is broken.
  final bool weekly;
  final List<Season> seasons;

  static const empty = RemoteConfig();

  /// Never throws: anything malformed is skipped.
  static RemoteConfig parse(String body) {
    try {
      final json = jsonDecode(body);
      if (json is! Map<String, dynamic>) {
        return empty;
      }
      final seasons = <Season>[];
      for (final entry in (json['seasons'] as List?) ?? const []) {
        final season = _season(entry);
        if (season != null) {
          seasons.add(season);
        }
      }
      return RemoteConfig(weekly: json['weekly'] != false, seasons: seasons);
    } catch (_) {
      return empty;
    }
  }

  static Season? _season(Object? entry) {
    if (entry is! Map<String, dynamic>) {
      return null;
    }
    final name = entry['name'];
    if (name is! String || name.isEmpty) {
      return null;
    }
    final from = DateTime.tryParse('${entry['from']}');
    final until = DateTime.tryParse('${entry['until']}');
    final enabled = entry['enabled'] != false;
    final builtIn = Season.builtIns.where((s) => s.palette.name == name).firstOrNull;
    final colors = entry['colors'];
    Palette? palette = builtIn?.palette;
    if (colors is Map<String, dynamic>) {
      palette = _palette(name, colors) ?? palette;
    }
    if (palette == null) {
      return null;
    }
    if (from != null && until != null) {
      return Season(
        palette: palette,
        from: DateTime.utc(from.year, from.month, from.day),
        until: DateTime.utc(until.year, until.month, until.day),
        enabled: enabled,
      );
    }
    if (builtIn == null) {
      return null;
    }
    return Season(
      palette: palette,
      fromMonthDay: builtIn.fromMonthDay,
      untilMonthDay: builtIn.untilMonthDay,
      enabled: enabled,
    );
  }

  static Palette? _palette(String name, Map<String, dynamic> c) {
    Color? hex(String key) {
      final v = c[key];
      if (v is! String) {
        return null;
      }
      final digits = v.startsWith('#') ? v.substring(1) : v;
      final n = int.tryParse(digits, radix: 16);
      if (n == null || digits.length != 6) {
        return null;
      }
      return Color(0xFF000000 | n);
    }

    final roles = ['bg', 'bgAlt', 'primary', 'secondary', 'accent', 'hazard', 'glow']
        .map(hex)
        .toList();
    if (roles.any((r) => r == null)) {
      return null;
    }
    return Palette(
      name: name,
      bg: roles[0]!,
      bgAlt: roles[1]!,
      primary: roles[2]!,
      secondary: roles[3]!,
      accent: roles[4]!,
      hazard: roles[5]!,
      glow: roles[6]!,
    );
  }

  /// Built-in seasons with remote changes applied, then remote-only seasons.
  List<Season> get effectiveSeasons {
    final byName = {for (final s in seasons) s.palette.name: s};
    return [
      for (final s in Season.builtIns) byName.remove(s.palette.name) ?? s,
      ...byName.values,
    ];
  }

  /// Palettes in season at [now].
  List<Palette> palettesAt(DateTime now) => [
    for (final s in effectiveSeasons)
      if (s.activeAt(now)) s.palette,
  ];
}
