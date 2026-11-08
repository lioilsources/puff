import 'dart:math' as math;

import 'environment.dart';

/// Every piece of music the game ships. [id] is the file stem under
/// `assets/audio/music/` and the key in its manifest.
enum Track {
  menu('menu', 'Pressure Rising'),
  vacuum1('vacuum_1', 'Orbit Decay', EnvironmentKind.vacuum),
  vacuum2('vacuum_2', 'Nebula Band', EnvironmentKind.vacuum),
  air1('air_1', 'Updraft', EnvironmentKind.air),
  air2('air_2', 'Tailwind', EnvironmentKind.air),
  water1('water_1', 'Caustics', EnvironmentKind.water),
  water2('water_2', 'Thermocline', EnvironmentKind.water),
  plasma1('plasma_1', 'Arc Jump', EnvironmentKind.plasma),
  plasma2('plasma_2', 'High Voltage', EnvironmentKind.plasma),
  gameOver('game_over', '', null, false);

  const Track(this.id, this.title, [this.environment, this.loops = true]);

  final String id;

  /// Shown in the HUD when the track starts; empty for stings.
  final String title;

  /// The environment this track belongs to; null for menu and stings.
  final EnvironmentKind? environment;
  final bool loops;

  String get asset => 'assets/audio/music/$id.ogg';

  static List<Track> of(EnvironmentKind env) => [
    for (final t in values)
      if (t.environment == env) t,
  ];
}

/// Which track plays next. No audio in here, only the rules:
/// an environment never repeats the track it played last.
class Jukebox {
  Jukebox(this.random);

  final math.Random random;
  final Map<EnvironmentKind, Track> _last = {};

  /// The track for a visit to [env]: a random one the first time, afterwards
  /// whichever was not played on the previous visit.
  Track pickFor(EnvironmentKind env) {
    final tracks = Track.of(env);
    final last = _last[env];
    final choice = last == null
        ? tracks[random.nextInt(tracks.length)]
        : _after(tracks, last);
    _last[env] = choice;
    return choice;
  }

  /// Skip: the track after the current one of [env].
  Track next(EnvironmentKind env) => pickFor(env);

  Track _after(List<Track> tracks, Track last) =>
      tracks[(tracks.indexOf(last) + 1) % tracks.length];
}
