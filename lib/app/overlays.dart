import 'package:flutter/material.dart';

import '../game/fx/post_process.dart';
import '../game/localized_names.dart';
import '../game/palette.dart';
import '../game/puff_game.dart';
import '../game/sim/environment.dart';
import '../game/sim/jukebox.dart';
import '../game/sim/modifier.dart';
import '../l10n/app_localizations.dart';
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
        final l10n = AppLocalizations.of(context);
        return OverlayScrim(
          palette: p,
          opacity: 0.55,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeonText('PUFF', color: p.primary, size: 56, weight: FontWeight.w800, spacing: 14),
              const SizedBox(height: 4),
              NeonText(
                l10n.tagline,
                color: p.glow.withValues(alpha: 0.8),
                size: 13,
                glow: false,
                spacing: 4,
              ),
              const SizedBox(height: 22),
              NeonButton(
                label: l10n.play,
                color: p.accent,
                primary: true,
                onTap: () {
                  game.audio.click();
                  game.startGame();
                },
              ),
              NeonText(
                l10n.bestScore(settings.highScoreFor(settings.environment)),
                color: p.secondary,
                size: 12,
                glow: false,
              ),
              const SizedBox(height: 18),
              NeonPicker<EnvironmentKind>(
                title: l10n.environmentTitle,
                palette: p,
                values: EnvironmentKind.values,
                selected: settings.environment,
                labelOf: l10n.environmentName,
                onSelect: (e) {
                  game.audio.click();
                  settings.update((s) => s.environment = e);
                  game.setEnvironment(Environment.byKind(e));
                },
              ),
              NeonPicker<ModifierKind>(
                title: l10n.modifierTitle,
                palette: p,
                values: ModifierKind.values,
                selected: settings.modifier,
                labelOf: l10n.modifierName,
                colorOf: (_) => p.accent,
                onSelect: (m) {
                  game.audio.click();
                  settings.update((s) => s.modifier = m);
                  game.setModifier(ModifierSpec.byKind(m));
                },
              ),
              NeonPicker<Palette>(
                title: l10n.paletteTitle,
                palette: p,
                values: Palette.builtIns,
                selected: settings.palette,
                labelOf: l10n.paletteName,
                colorOf: (pal) => pal.primary,
                onSelect: (pal) {
                  game.audio.click();
                  settings.update((s) => s.paletteName = pal.name);
                  game.setPalette(pal);
                },
              ),
              const SizedBox(height: 12),
              if (gameCenter.offered)
                NeonButton(
                  label: l10n.leaderboard,
                  color: p.accent,
                  onTap: () {
                    game.audio.click();
                    gameCenter.show(settings.environment);
                  },
                ),
              NeonButton(
                label: l10n.settings,
                color: p.secondary,
                onTap: () {
                  game.audio.click();
                  game.overlays.add(PuffGame.settingsOverlay);
                },
              ),
              ValueListenableBuilder<Track?>(
                valueListenable: game.jukebox.nowPlaying,
                builder: (context, track, _) => NeonText(
                  track == null ? '' : '♪ ${track.title.toLowerCase()}',
                  color: p.secondary.withValues(alpha: 0.7),
                  size: 11,
                  glow: false,
                ),
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
        alignment: AlignmentDirectional.topEnd,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(top: 6, end: 10),
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
    // MUSIC is switched in the settings that open on top of this screen.
    return ListenableBuilder(listenable: settings, builder: (context, _) => _menu(AppLocalizations.of(context)));
  }

  Widget _menu(AppLocalizations l10n) {
    final p = settings.palette;
    return OverlayScrim(
      palette: p,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NeonText(l10n.paused, color: p.primary, size: 32, spacing: 8),
          const SizedBox(height: 20),
          NeonButton(
            label: l10n.resume,
            color: p.accent,
            primary: true,
            onTap: () {
              game.audio.click();
              game.resume();
            },
          ),
          NeonButton(
            label: l10n.restart,
            color: p.primary,
            onTap: () {
              game.audio.click();
              game.startGame();
            },
          ),
          if (settings.music)
            NeonButton(
              label: l10n.nextTrack,
              color: p.secondary,
              onTap: () {
                game.audio.click();
                game.jukebox.skip();
              },
            ),
          NeonButton(
            label: l10n.settings,
            color: p.secondary,
            onTap: () {
              game.audio.click();
              game.overlays.add(PuffGame.settingsOverlay);
            },
          ),
          NeonButton(
            label: l10n.menu,
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
    final l10n = AppLocalizations.of(context);
    return OverlayScrim(
      palette: p,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NeonText(l10n.gameOver, color: p.hazard, size: 30, spacing: 8),
          const SizedBox(height: 16),
          NeonText('${s.score}', color: p.primary, size: 48, weight: FontWeight.w800),
          NeonText(
            isBest ? l10n.newBest : l10n.bestScore(best),
            color: isBest ? p.accent : p.secondary,
            size: 13,
            glow: isBest,
          ),
          const SizedBox(height: 10),
          NeonText(
            '${l10n.gameOverStats(s.bestCombo, s.bodiesDisplaced, s.fractures)}\n'
            '${l10n.gameOverRun(
              l10n.environmentName(game.environment.kind),
              l10n.modifierName(game.modifiers.spec.kind),
              game.elapsed.toStringAsFixed(0),
            )}',
            color: p.glow.withValues(alpha: 0.8),
            size: 12,
            glow: false,
            spacing: 1,
          ),
          const SizedBox(height: 20),
          NeonButton(
            label: l10n.again,
            color: p.accent,
            primary: true,
            onTap: () {
              game.audio.click();
              game.startGame();
            },
          ),
          NeonButton(
            label: l10n.menu,
            color: p.secondary,
            onTap: () {
              game.audio.click();
              game.backToMenu();
            },
          ),
          if (gameCenter.offered)
            NeonButton(
              label: l10n.leaderboard,
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
        final l10n = AppLocalizations.of(context);
        return OverlayScrim(
          palette: p,
          opacity: 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeonText(l10n.settings, color: p.primary, size: 28, spacing: 8),
              const SizedBox(height: 16),
              NeonPicker<PostProcessQuality>(
                title: l10n.quality,
                palette: p,
                values: PostProcessQuality.values,
                selected: settings.quality,
                labelOf: l10n.qualityName,
                onSelect: (q) {
                  game.audio.click();
                  settings.update((s) => s.quality = q);
                  game.setQuality(q);
                },
              ),
              const SizedBox(height: 8),
              NeonToggle(
                label: l10n.haptics,
                value: settings.haptics,
                color: p.accent,
                onChanged: (v) {
                  game.audio.click();
                  settings.update((s) => s.haptics = v);
                  game.haptics.enabled = v;
                },
              ),
              NeonToggle(
                label: l10n.sound,
                value: settings.sound,
                color: p.accent,
                onChanged: (v) {
                  settings.update((s) => s.sound = v);
                  game.audio.enabled = v;
                  game.audio.click();
                },
              ),
              NeonToggle(
                label: l10n.music,
                value: settings.music,
                color: p.accent,
                onChanged: (v) {
                  game.audio.click();
                  settings.update((s) => s.music = v);
                  game.jukebox.enabled = v;
                },
              ),
              NeonToggle(
                label: l10n.debugOverlay,
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
                label: l10n.back,
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
