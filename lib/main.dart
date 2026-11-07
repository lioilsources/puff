import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app/deep_link.dart';
import 'app/game_center.dart';
import 'app/overlays.dart';
import 'app/remote_config.dart';
import 'app/review_policy.dart';
import 'app/settings.dart';
import 'l10n/app_localizations.dart';
import 'game/palette.dart';
import 'game/puff_game.dart';
import 'game/sim/achievements.dart';
import 'game/sim/environment.dart';
import 'game/sim/modifier.dart';
import 'game/sim/weekly.dart';
import 'game/tuning.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await _configureAudioSession();
  final settings = await PuffSettings.load();
  // Before the game reads the palette: a seasonal one may be selected.
  final remote = RemoteConfigLoader(settings.prefs);
  runApp(PuffApp(settings: settings, remote: remote));
}

/// iOS: sound effects and music follow the silent switch, like any casual
/// game. `audioplayers` defaults to the playback category, which ignores it;
/// SoLoud leaves the session alone and inherits whatever is set here.
Future<void> _configureAudioSession() async {
  if (defaultTargetPlatform != TargetPlatform.iOS) {
    return;
  }
  try {
    await AudioPlayer.global.setAudioContext(
      AudioContext(iOS: AudioContextIOS(category: AVAudioSessionCategory.soloAmbient)),
    );
  } catch (error) {
    debugPrint('Puff: audio session not configured: $error');
  }
}

class PuffApp extends StatefulWidget {
  const PuffApp({super.key, required this.settings, required this.remote});

  final PuffSettings settings;
  final RemoteConfigLoader remote;

  @override
  State<PuffApp> createState() => _PuffAppState();
}

class _PuffAppState extends State<PuffApp> {
  late final PuffGame game;
  final gameCenter = GameCenter();
  late final AppLifecycleListener _lifecycle;
  final _links = AppLinks();
  StreamSubscription<Uri>? _linkSub;
  StreamSubscription<GameActivity>? _activitySub;
  static const _review = ReviewPolicy();
  static const _rules = AchievementRules(
    comboStep: Tuning.comboStep,
    paletteCount: 6,
  );

  @override
  void initState() {
    super.initState();
    // Flame stops the game loop in the background, the audio thread does not.
    _lifecycle = AppLifecycleListener(
      onStateChange: (state) {
        if (!game.isLoaded) {
          return;
        }
        if (state == AppLifecycleState.resumed) {
          game.jukebox.resume();
        } else {
          game.jukebox.suspend();
        }
      },
    );
    final s = widget.settings;
    game = PuffGame(
      palette: s.palette,
      environment: Environment.byKind(s.environment),
      modifier: ModifierSpec.byKind(s.modifier),
      quality: s.quality,
      hapticsEnabled: s.haptics,
      soundEnabled: s.sound,
      // Scripted screenshot runs stay silent and keep the title off the HUD.
      musicEnabled: s.music && !PuffGame.demoMode,
      debugOverlayEnabled: s.debugOverlay,
      onRunFinished: _runFinished,
    );
    gameCenter
      ..pendingAchievements = (() => s.achievements.unlocked.difference(s.reportedAchievements))
      ..onReported = s.markReported;
    _activitySub = gameCenter.activities.listen(_onActivity);
    gameCenter.signIn();
    _linkSub = _links.uriLinkStream.listen(_onLink, onError: (Object e) {
      debugPrint('Puff: deep link failed: $e');
    });
    widget.remote.addListener(_onRemoteConfig);
    widget.remote.refresh();
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _linkSub?.cancel();
    _activitySub?.cancel();
    widget.remote.removeListener(_onRemoteConfig);
    gameCenter.dispose();
    super.dispose();
  }

  /// The week's challenge, unless the remote config switched it off.
  WeeklyChallenge? get weekly => widget.remote.config.weekly
      ? WeeklyChallenge.at(DateTime.now(), preview: _weeklyPreview)
      : null;

  /// Shows the weekly challenge before its launch date:
  /// `--dart-define=PUFF_WEEKLY=true`.
  static const _weeklyPreview = bool.fromEnvironment('PUFF_WEEKLY');

  Future<bool> _runFinished(PuffGame game, int score) async {
    final s = widget.settings;
    final week = game.weekly;
    gameCenter.submit(game.environment.kind, score, weekly: week);
    final best = week == null
        ? await s.submitScore(game.environment.kind, score)
        : await s.submitWeekly(week.id, score);

    final run = game.runRecord();
    if (_rules.record(run, s.achievements).isNotEmpty) {
      await s.saveAchievements();
      gameCenter.reportAchievements();
    } else {
      await s.saveAchievements();
    }

    _maybeAskForReview(best: best, comboX4: run.bestCombo >= _rules.comboForX4);
    return best;
  }

  Future<void> _maybeAskForReview({required bool best, required bool comboX4}) async {
    if (PuffGame.demoMode) {
      return;
    }
    final s = widget.settings;
    try {
      final version = (await PackageInfo.fromPlatform()).version;
      if (!_review.shouldAsk(
        appVersion: version,
        lastAskedVersion: s.lastReviewVersion,
        session: s.session,
        newBest: best,
        comboX4: comboX4,
      )) {
        return;
      }
      final review = InAppReview.instance;
      if (!await review.isAvailable()) {
        return;
      }
      await s.markReviewAsked(version);
      // Let the game-over screen land first.
      await Future<void>.delayed(const Duration(milliseconds: 1400));
      if (game.phase == GamePhase.gameOver) {
        await review.requestReview();
      }
    } catch (error) {
      debugPrint('Puff: review prompt failed: $error');
    }
  }

  void _onRemoteConfig() {
    final s = widget.settings;
    // A seasonal palette that went out of season falls back on its own via
    // [Palette.byName]; tell the menu and the game.
    game.setPalette(s.palette);
    s.update((_) {});
  }

  void _onLink(Uri uri) {
    if (!game.isLoaded) {
      // Cold start: wait for the game, then try again.
      game.loaded.then((_) => _onLink(uri));
      return;
    }
    final s = widget.settings;
    switch (DeepLink.parse(uri)) {
      case StartRun():
        game.startGame();
      case StartWeekly():
        final week = weekly;
        week == null ? game.backToMenu() : game.startGame(challenge: week);
      case SelectPalette(:final name):
        final palette = Palette.available
            .where((p) => p.name.toLowerCase() == name)
            .firstOrNull;
        if (palette != null) {
          s.update((s) => s.paletteName = palette.name);
          game.setPalette(palette);
        }
        game.backToMenu();
      case OpenEvent():
      case OpenMenu():
        game.backToMenu();
    }
  }

  /// A game activity from Game Center: its properties pick the run.
  /// `mode: weekly` plays the week; otherwise `environment` and `modifier`
  /// (by name) set up a free run.
  void _onActivity(GameActivity activity) {
    if (!game.isLoaded) {
      game.loaded.then((_) => _onActivity(activity));
      return;
    }
    final p = activity.properties;
    final week = weekly;
    if (p['mode'] == 'weekly' && week != null) {
      game.startGame(challenge: week);
      return;
    }
    final s = widget.settings;
    final env = EnvironmentKind.values.where((e) => e.name == p['environment']).firstOrNull;
    final mod = ModifierKind.values.where((m) => m.name == p['modifier']).firstOrNull;
    s.update((s) {
      if (env != null) s.environment = env;
      if (mod != null) s.modifier = mod;
    });
    game.backToMenu();
    game.setEnvironment(Environment.byKind(s.environment));
    game.setModifier(ModifierSpec.byKind(s.modifier));
    game.startGame();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.settings;
    return MaterialApp(
      title: 'Puff',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        backgroundColor: s.palette.bg,
        body: Builder(
          builder: (context) {
            final padding = MediaQuery.paddingOf(context);
            game.safeTop = padding.top;
            game.calm = s.reducedFlashes || MediaQuery.disableAnimationsOf(context);
            game.safeBottom = padding.bottom;
            game.l10n = AppLocalizations.of(context);
            game.textDirection = Directionality.of(context);
            return GameWidget<PuffGame>(
              game: game,
              overlayBuilderMap: {
                PuffGame.menuOverlay: (_, g) => MainMenuOverlay(
                  game: g,
                  settings: s,
                  gameCenter: gameCenter,
                  weekly: () => weekly,
                ),
                PuffGame.hudOverlay: (_, g) => HudOverlay(game: g, settings: s),
                PuffGame.pauseOverlay: (_, g) =>
                    PauseOverlay(game: g, settings: s),
                PuffGame.gameOverOverlay: (_, g) =>
                    GameOverOverlay(game: g, settings: s, gameCenter: gameCenter),
                PuffGame.settingsOverlay: (_, g) =>
                    SettingsOverlay(game: g, settings: s),
              },
            );
          },
        ),
      ),
    );
  }
}
