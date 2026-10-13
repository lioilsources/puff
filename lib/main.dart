import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/game_center.dart';
import 'app/overlays.dart';
import 'app/settings.dart';
import 'game/puff_game.dart';
import 'game/sim/environment.dart';
import 'game/sim/modifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await _configureAudioSession();
  final settings = await PuffSettings.load();
  runApp(PuffApp(settings: settings));
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
  const PuffApp({super.key, required this.settings});

  final PuffSettings settings;

  @override
  State<PuffApp> createState() => _PuffAppState();
}

class _PuffAppState extends State<PuffApp> {
  late final PuffGame game;
  final gameCenter = GameCenter();
  late final AppLifecycleListener _lifecycle;

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
      onRunFinished: (game, score) {
        gameCenter.submit(game.environment.kind, score);
        return s.submitScore(game.environment.kind, score);
      },
    );
    gameCenter.signIn();
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    gameCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.settings;
    return MaterialApp(
      title: 'Puff',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        backgroundColor: s.palette.bg,
        body: Builder(
          builder: (context) {
            final padding = MediaQuery.paddingOf(context);
            game.safeTop = padding.top;
            game.safeBottom = padding.bottom;
            return GameWidget<PuffGame>(
              game: game,
              overlayBuilderMap: {
                PuffGame.menuOverlay: (_, g) =>
                    MainMenuOverlay(game: g, settings: s, gameCenter: gameCenter),
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
