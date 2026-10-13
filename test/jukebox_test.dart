import 'dart:math' as math;

import 'package:puff/game/sim/environment.dart';
import 'package:puff/game/sim/jukebox.dart';
import 'package:test/test.dart';

void main() {
  test('every environment has two looping tracks of its own', () {
    for (final env in EnvironmentKind.values) {
      final tracks = Track.of(env);
      expect(tracks, hasLength(2), reason: env.name);
      expect(tracks.every((t) => t.loops && t.title.isNotEmpty), isTrue);
    }
    expect(Track.menu.environment, isNull);
    expect(Track.gameOver.loops, isFalse);
  });

  test('ids are unique and name the asset', () {
    expect({for (final t in Track.values) t.id}, hasLength(Track.values.length));
    expect(Track.water2.asset, 'assets/audio/music/water_2.ogg');
  });

  test('an environment never repeats the track of its previous visit', () {
    for (var seed = 0; seed < 20; seed++) {
      final jukebox = Jukebox(math.Random(seed));
      var last = jukebox.pickFor(EnvironmentKind.water);
      expect(last.environment, EnvironmentKind.water);
      for (var i = 0; i < 6; i++) {
        final next = jukebox.pickFor(EnvironmentKind.water);
        expect(next, isNot(last));
        expect(next.environment, EnvironmentKind.water);
        last = next;
      }
    }
  });

  test('environments keep separate histories', () {
    final jukebox = Jukebox(math.Random(1));
    final water = jukebox.pickFor(EnvironmentKind.water);
    jukebox.pickFor(EnvironmentKind.plasma);
    jukebox.pickFor(EnvironmentKind.plasma);
    expect(jukebox.pickFor(EnvironmentKind.water), isNot(water));
  });

  test('skip gives the other track, then the first one again', () {
    final jukebox = Jukebox(math.Random(3));
    final first = jukebox.pickFor(EnvironmentKind.air);
    final second = jukebox.next(EnvironmentKind.air);
    expect(second, isNot(first));
    expect(jukebox.next(EnvironmentKind.air), first);
  });

  test('the same seed gives the same sequence', () {
    List<Track> run() {
      final jukebox = Jukebox(math.Random(7));
      return [
        for (final env in [...EnvironmentKind.values, ...EnvironmentKind.values])
          jukebox.pickFor(env),
      ];
    }

    expect(run(), run());
  });
}
