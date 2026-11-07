import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/palette.dart';
import '../game/sim/season.dart';

/// Loads [RemoteConfig]: the copy saved last time at once, a fresh one in
/// the background. A plain GET of a static file, nothing is sent about the
/// player. With no network and nothing saved, the built-in seasons apply.
class RemoteConfigLoader extends ChangeNotifier {
  RemoteConfigLoader(this._prefs) {
    _apply(RemoteConfig.parse(_prefs.getString(_key) ?? ''));
  }

  static const _key = 'remoteConfig';
  final SharedPreferences _prefs;

  RemoteConfig config = RemoteConfig.empty;

  void _apply(RemoteConfig value) {
    config = value;
    Palette.inSeason = value.palettesAt(DateTime.now());
    notifyListeners();
  }

  Future<void> refresh() async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
    try {
      final request = await client.getUrl(Uri.parse(RemoteConfig.url));
      final response = await request.close().timeout(const Duration(seconds: 8));
      if (response.statusCode != HttpStatus.ok) {
        await response.drain<void>();
        return;
      }
      final body = await response.transform(utf8.decoder).join();
      if (!body.trimLeft().startsWith('{')) {
        return;
      }
      await _prefs.setString(_key, body);
      _apply(RemoteConfig.parse(body));
    } catch (error) {
      debugPrint('Puff: remote config not loaded: $error');
    } finally {
      client.close(force: true);
    }
  }
}
