import '../l10n/app_localizations.dart';
import 'fx/post_process.dart';
import 'palette.dart';
import 'sim/environment.dart';
import 'sim/modifier.dart';

/// Display names for game data. The English names in `sim/` and `palette.dart`
/// stay as stable identifiers (settings keys, leaderboard ids); players see
/// these instead.
extension LocalizedNames on AppLocalizations {
  String environmentName(EnvironmentKind kind) => switch (kind) {
    EnvironmentKind.vacuum => envVacuum,
    EnvironmentKind.air => envAir,
    EnvironmentKind.water => envWater,
    EnvironmentKind.plasma => envPlasma,
  };

  String modifierName(ModifierKind kind) => switch (kind) {
    ModifierKind.pressure => modPressure,
    ModifierKind.implosion => modImplosion,
    ModifierKind.magnet => modMagnet,
    ModifierKind.gravityWell => modGravityWell,
    ModifierKind.chainSpark => modChainSpark,
  };

  /// Built-in palettes are translated; any other palette keeps its own name.
  String paletteName(Palette palette) => switch (palette.name) {
    'Cyberpunk' => paletteCyberpunk,
    'Vaporwave' => paletteVaporwave,
    'Acid' => paletteAcid,
    'Mono' => paletteMono,
    'Ember' => paletteEmber,
    'Arctic' => paletteArctic,
    _ => palette.name,
  };

  String qualityName(PostProcessQuality quality) => switch (quality) {
    PostProcessQuality.low => qualityLow,
    PostProcessQuality.med => qualityMed,
    PostProcessQuality.high => qualityHigh,
  };

  /// Heat tier announcement; tier 0 and 1 are silent.
  String heatTierName(int tier) => switch (tier) {
    <= 0 => '',
    1 => heatTier1,
    2 => heatTier2,
    3 => heatTier3,
    _ => heatTierOverdrive,
  };
}
