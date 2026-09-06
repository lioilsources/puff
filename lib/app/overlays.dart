import 'package:flutter/material.dart';

import '../game/fx/post_process.dart';
import '../game/palette.dart';
import '../game/puff_game.dart';
import '../game/sim/environment.dart';
import '../game/sim/modifier.dart';
import 'game_center.dart';
import 'settings.dart';
import 'theme.dart';

class MainMenuOverlay extends StatelessWidget {
  const MainMenuOverlay({
    super.key,
    required this.game,
    required this.settings,
    required this.gameCenter,
  });

  final PuffGame game;
  final PuffSettings settings;
  final GameCenter gameCenter;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      // Game Center signs in after the menu is already up.
      animation: Listenable.merge([settings, gameCenter]),
      builder: (context, _) {
        final p = settings.palette;
        return OverlayScrim(
          palette: p,
          opacity: 0.55,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeonText('PUFF', color: p.primary, size: 56, weight: FontWeight.w800, spacing: 14),
              const SizedBox(height: 4),
              NeonText(
                'hold · drag · release',
                color: p.glow.withValues(alpha: 0.8),
                size: 13,
                glow: false,
                spacing: 4,
              ),
              const SizedBox(height: 22),
              NeonButton(
                label: 'PLAY',
                color: p.accent,
                primary: true,
                onTap: () {
                  game.audio.click();
                  game.startGame();
                },
              ),
              NeonText(
                'best · ${settings.highScoreFor(settings.environment)}',
                color: p.secondary,
                size: 12,
                glow: false,
              ),
              const SizedBox(height: 18),
              NeonPicker<EnvironmentKind>(
                title: 'ENVIRONMENT',
                palette: p,
                values: EnvironmentKind.values,
                selected: settings.environment,
                labelOf: (e) => Environment.byKind(e).name,
                onSelect: (e) {
                  game.audio.click();
                  settings.update((s) => s.environment = e);
                  game.setEnvironment(Environment.byKind(e));
                },
              ),
              NeonPicker<ModifierKind>(
                title: 'MODIFIER',
                palette: p,
                values: ModifierKind.values,
                selected: settings.modifier,
                labelOf: (m) => ModifierSpec.byKind(m).name,
                colorOf: (_) => p.accent,
                onSelect: (m) {
                  game.audio.click();
                  settings.update((s) => s.modifier = m);
                  game.setModifier(ModifierSpec.byKind(m));
                },
              ),
              NeonPicker<Palette>(
                title: 'PALETTE',
                palette: p,
                values: Palette.builtIns,
                selected: settings.palette,
                labelOf: (pal) => pal.name,
                colorOf: (pal) => pal.primary,
                onSelect: (pal) {
                  game.audio.click();
                  settings.update((s) => s.paletteName = pal.name);
                  game.setPalette(pal);
                },
              ),
              const SizedBox(height: 12),
              if (gameCenter.available)
                NeonButton(
                  label: 'LEADERBOARD',
                  color: p.accent,
                  onTap: () {
                    game.audio.click();
                    gameCenter.show(settings.environment);
                  },
                ),
              NeonButton(
                label: 'SETTINGS',
                color: p.secondary,
                onTap: () {
                  game.audio.click();
                  game.overlays.add(PuffGame.settingsOverlay);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class HudOverlay extends StatelessWidget {
  const HudOverlay({super.key, required this.game, required this.settings});

  final PuffGame game;
  final PuffSettings settings;

  @override
  Widget build(BuildContext context) {
    final p = settings.palette;
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 6, right: 10),
          child: IconButton(
            iconSize: 26,
            color: p.secondary.withValues(alpha: 0.85),
            icon: const Icon(Icons.pause_rounded),
            onPressed: () {
              game.audio.click();
              game.pause();
            },
          ),
        ),
      ),
    );
  }
}

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key, required this.game, required this.settings});

  final PuffGame game;
  final PuffSettings settings;

  @override
  Widget build(BuildContext context) {
    final p = settings.palette;
    return OverlayScrim(
      palette: p,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NeonText('PAUSED', color: p.primary, size: 32, spacing: 8),
          const SizedBox(height: 20),
          NeonButton(
            label: 'RESUME',
            color: p.accent,
            primary: true,
            onTap: () {
              game.audio.click();
              game.resume();
            },
          ),
          NeonButton(
            label: 'RESTART',
            color: p.primary,
            onTap: () {
              game.audio.click();
              game.startGame();
            },
          ),
          NeonButton(
            label: 'SETTINGS',
            color: p.secondary,
            onTap: () {
              game.audio.click();
              game.overlays.add(PuffGame.settingsOverlay);
            },
          ),
          NeonButton(
            label: 'MENU',
            color: p.secondary,
            onTap: () {
              game.audio.click();
              game.backToMenu();
            },
          ),
        ],
      ),
    );
  }
}

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({
    super.key,
    required this.game,
    required this.settings,
    required this.gameCenter,
  });

  final PuffGame game;
  final PuffSettings settings;
  final GameCenter gameCenter;

  @override
  Widget build(BuildContext context) {
    final p = settings.palette;
    final s = game.score;
    final best = settings.highScoreFor(settings.environment);
    final isBest = game.lastRunWasBest;
    return OverlayScrim(
      palette: p,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NeonText('GAME OVER', color: p.hazard, size: 30, spacing: 8),
          const SizedBox(height: 16),
          NeonText('${s.score}', color: p.primary, size: 48, weight: FontWeight.w800),
          NeonText(
            isBest ? 'NEW BEST' : 'best · $best',
            color: isBest ? p.accent : p.secondary,
            size: 13,
            glow: isBest,
          ),
          const SizedBox(height: 10),
          NeonText(
            'combo x${s.bestCombo}   displaced ${s.bodiesDisplaced}   broken ${s.fractures}\n'
            '${game.environment.name} · ${game.modifiers.spec.name} · ${game.elapsed.toStringAsFixed(0)}s',
            color: p.glow.withValues(alpha: 0.8),
            size: 12,
            glow: false,
            spacing: 1,
          ),
          const SizedBox(height: 20),
          NeonButton(
            label: 'AGAIN',
            color: p.accent,
            primary: true,
            onTap: () {
              game.audio.click();
              game.startGame();
            },
          ),
          NeonButton(
            label: 'MENU',
            color: p.secondary,
            onTap: () {
              game.audio.click();
              game.backToMenu();
            },
          ),
          if (gameCenter.available)
            NeonButton(
              label: 'LEADERBOARD',
              color: p.glow.withValues(alpha: 0.8),
              onTap: () {
                game.audio.click();
                gameCenter.show(game.environment.kind);
              },
            ),
        ],
      ),
    );
  }
}

class SettingsOverlay extends StatelessWidget {
  const SettingsOverlay({super.key, required this.game, required this.settings});

  final PuffGame game;
  final PuffSettings settings;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        final p = settings.palette;
        return OverlayScrim(
          palette: p,
          opacity: 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeonText('SETTINGS', color: p.primary, size: 28, spacing: 8),
              const SizedBox(height: 16),
              NeonPicker<PostProcessQuality>(
                title: 'QUALITY',
                palette: p,
                values: PostProcessQuality.values,
                selected: settings.quality,
                labelOf: (q) => q.name.toUpperCase(),
                onSelect: (q) {
                  game.audio.click();
                  settings.update((s) => s.quality = q);
                  game.setQuality(q);
                },
              ),
              const SizedBox(height: 8),
              NeonToggle(
                label: 'HAPTICS',
                value: settings.haptics,
                color: p.accent,
                onChanged: (v) {
                  game.audio.click();
                  settings.update((s) => s.haptics = v);
                  game.haptics.enabled = v;
                },
              ),
              NeonToggle(
                label: 'SOUND',
                value: settings.sound,
                color: p.accent,
                onChanged: (v) {
                  settings.update((s) => s.sound = v);
                  game.audio.enabled = v;
                  game.audio.click();
                },
              ),
              NeonToggle(
                label: 'DEBUG OVERLAY',
                value: settings.debugOverlay,
                color: p.secondary,
                onChanged: (v) {
                  game.audio.click();
                  settings.update((s) => s.debugOverlay = v);
                  game.showDebugOverlay(v);
                },
              ),
              const SizedBox(height: 16),
              NeonButton(
                label: 'BACK',
                color: p.primary,
                primary: true,
                onTap: () {
                  game.audio.click();
                  game.overlays.remove(PuffGame.settingsOverlay);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
