import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:puff/game/sim/jukebox.dart';
import 'package:test/test.dart';

/// The manifest, the [Track] enum and the files in `assets/audio/music/` are
/// three lists of the same thing; this keeps them from drifting apart.
void main() {
  final manifest =
      jsonDecode(File('tool/music_manifest.json').readAsStringSync()) as Map<String, dynamic>;
  final tracks = [for (final t in manifest['tracks'] as List) t as Map<String, dynamic>];

  test('manifest and Track list the same ids, titles and loop flags', () {
    expect({for (final t in tracks) t['id']}, {for (final t in Track.values) t.id});
    for (final track in Track.values) {
      final entry = tracks.firstWhere((t) => t['id'] == track.id);
      expect(entry['title'], track.title, reason: track.id);
      expect(entry['loop'], track.loops, reason: track.id);
    }
  });

  test('every generated track is on disk, unchanged', () {
    for (final entry in tracks) {
      final expected = entry['sha256'];
      if (expected == null) {
        continue; // not generated yet
      }
      final file = File('assets/audio/music/${entry['id']}.ogg');
      expect(file.existsSync(), isTrue, reason: '${entry['id']} is missing');
      expect(sha256.convert(file.readAsBytesSync()).toString(), expected, reason: '${entry['id']}');
    }
  });

  test('no stray music files', () {
    final dir = Directory('assets/audio/music');
    if (!dir.existsSync()) {
      return;
    }
    final known = {for (final t in tracks) '${t['id']}.ogg'};
    for (final file in dir.listSync().whereType<File>()) {
      final name = file.uri.pathSegments.last;
      if (name.startsWith('.')) {
        continue;
      }
      expect(known, contains(name), reason: '$name is not in the manifest');
    }
  });
}
