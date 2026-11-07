// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get tagline => 'maintiens · glisse · relâche';

  @override
  String get play => 'JOUER';

  @override
  String bestScore(int score) {
    return 'record · $score';
  }

  @override
  String get environmentTitle => 'ENVIRONNEMENT';

  @override
  String get modifierTitle => 'MODIFICATEUR';

  @override
  String get paletteTitle => 'PALETTE';

  @override
  String get leaderboard => 'CLASSEMENT';

  @override
  String get settings => 'RÉGLAGES';

  @override
  String get paused => 'PAUSE';

  @override
  String get resume => 'REPRENDRE';

  @override
  String get restart => 'RECOMMENCER';

  @override
  String get nextTrack => '♪ PISTE SUIVANTE';

  @override
  String get menu => 'MENU';

  @override
  String get gameOver => 'PARTIE TERMINÉE';

  @override
  String get newBest => 'NOUVEAU RECORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'combo x$combo   déplacés $displaced   brisés $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'REJOUER';

  @override
  String get quality => 'QUALITÉ';

  @override
  String get qualityLow => 'BASSE';

  @override
  String get qualityMed => 'MOYENNE';

  @override
  String get qualityHigh => 'HAUTE';

  @override
  String get haptics => 'VIBRATIONS';

  @override
  String get sound => 'SONS';

  @override
  String get music => 'MUSIQUE';

  @override
  String get debugOverlay => 'DÉBOGAGE';

  @override
  String get back => 'RETOUR';

  @override
  String get on => 'OUI';

  @override
  String get off => 'NON';

  @override
  String get envVacuum => 'Vide';

  @override
  String get envAir => 'Air';

  @override
  String get envWater => 'Eau';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Pression';

  @override
  String get modImplosion => 'Implosion';

  @override
  String get modMagnet => 'Aimant';

  @override
  String get modGravityWell => 'Puits gravitationnel';

  @override
  String get modChainSpark => 'Étincelle en chaîne';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Acide';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Braise';

  @override
  String get paletteArctic => 'Arctique';

  @override
  String get heatTier1 => 'CHALEUR I';

  @override
  String get heatTier2 => 'CHALEUR II';

  @override
  String get heatTier3 => 'CHALEUR III';

  @override
  String get heatTierOverdrive => 'SURCHAUFFE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  combo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  échappés $escaped/$max';
  }

  @override
  String get weekly => 'DÉFI DE LA SEMAINE';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'encore $days jours',
      one: 'encore 1 jour',
      zero: 'dernier jour',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'record de la semaine · $score';
  }

  @override
  String get achievements => 'SUCCÈS';

  @override
  String get challenges => 'DÉFIS';

  @override
  String get share => 'PARTAGER';

  @override
  String shareText(int score, String link) {
    return 'Mon nouveau record dans Puff : $score. Tu fais mieux ? $link';
  }

  @override
  String get reducedFlashes => 'MOINS DE FLASHS';

  @override
  String get paletteHoliday => 'Fêtes';

  @override
  String get supporter => 'SOUTIEN';

  @override
  String get tipJar => 'POURBOIRE';

  @override
  String get tipJarInfo =>
      'Puff reste gratuit et sans publicité. Un pourboire ne débloque rien : il dit simplement merci et ajoute un badge de soutien au menu.';

  @override
  String get tipSmall => 'PETIT POURBOIRE';

  @override
  String get tipMedium => 'POURBOIRE MOYEN';

  @override
  String get tipLarge => 'GROS POURBOIRE';

  @override
  String get tipThanks => 'MERCI !';

  @override
  String get tipFailed => 'L\'ACHAT N\'A PAS ABOUTI';
}
