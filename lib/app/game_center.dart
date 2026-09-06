import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:games_services/games_services.dart';

import '../game/sim/environment.dart';

/// Game Center leaderboards, one per environment.
///
/// Every call here is best-effort. Game Center does not exist on Android, the
/// player is free to decline the sign-in, and a submission can fail with no
/// network. None of that is worth interrupting a run over, so failures are
/// swallowed and [available] simply stays false — the UI then keeps its
/// leaderboard entry point hidden and the local high scores carry on alone.
class GameCenter extends ChangeNotifier {
  bool _available = false;
  StreamSubscription<PlayerData?>? _player;

  /// True once the player is signed in and submissions can be made.
  bool get available => _available;

  /// Board IDs as created in App Store Connect. Scores differ by an order of
  /// magnitude between environments, so they get a board each rather than one
  /// table the easiest environment would own.
  static String leaderboardId(EnvironmentKind env) => 'puff.${env.name}';

  static bool get _supported =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  /// Signs in silently at startup. Game Center shows its own banner.
  ///
  /// The player stream, not the result of [GameAuth.signIn], is what decides
  /// [available]: authentication can complete well after the call returns, and
  /// the player may sign in from iOS Settings while the game is running.
  Future<void> signIn() async {
    if (!_supported) {
      return;
    }
    _player ??= GameAuth.player.listen(
      (player) => _setAvailable(player != null),
      onError: (Object error) {
        debugPrint('Puff: Game Center player stream failed: $error');
        _setAvailable(false);
      },
    );
    try {
      await GameAuth.signIn();
    } catch (error) {
      debugPrint('Puff: Game Center sign-in failed: $error');
    }
  }

  void _setAvailable(bool value) {
    if (value == _available) {
      return;
    }
    _available = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _player?.cancel();
    super.dispose();
  }

  /// Posts a finished run. Game Center keeps the best of what it is sent, so
  /// every run goes up, not only local bests.
  Future<void> submit(EnvironmentKind env, int score) async {
    if (!_available) {
      return;
    }
    try {
      await Leaderboards.submitScore(
        score: Score(iOSLeaderboardID: leaderboardId(env), value: score),
      );
    } catch (error) {
      debugPrint('Puff: Game Center submit failed: $error');
    }
  }

  /// Opens the system leaderboard for [env].
  Future<void> show(EnvironmentKind env) async {
    if (!_available) {
      return;
    }
    try {
      await Leaderboards.showLeaderboards(
        iOSLeaderboardID: leaderboardId(env),
      );
    } catch (error) {
      debugPrint('Puff: Game Center leaderboard failed to open: $error');
    }
  }
}
