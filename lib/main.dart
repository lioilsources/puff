import 'package:flame/game.dart';
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
  final settings = await PuffSettings.load();
  runApp(PuffApp(settings: settings));
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

  @override
  void initState() {
    super.initState();
    final s = widget.settings;
    game = PuffGame(
      palette: s.palette,
      environment: Environment.byKind(s.environment),
      modifier: ModifierSpec.byKind(s.modifier),
      quality: s.quality,
      hapticsEnabled: s.haptics,
      soundEnabled: s.sound,
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
