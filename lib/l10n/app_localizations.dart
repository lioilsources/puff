import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('gu'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('kn'),
    Locale('ko'),
    Locale('ml'),
    Locale('mr'),
    Locale('ms'),
    Locale('nb'),
    Locale('nl'),
    Locale('or'),
    Locale('pa'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('pt', 'PT'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sv'),
    Locale('ta'),
    Locale('te'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// Main menu subtitle: the three gestures of the game.
  ///
  /// In en, this message translates to:
  /// **'hold · drag · release'**
  String get tagline;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'PLAY'**
  String get play;

  /// Best score for the selected environment.
  ///
  /// In en, this message translates to:
  /// **'best · {score}'**
  String bestScore(int score);

  /// No description provided for @environmentTitle.
  ///
  /// In en, this message translates to:
  /// **'ENVIRONMENT'**
  String get environmentTitle;

  /// No description provided for @modifierTitle.
  ///
  /// In en, this message translates to:
  /// **'MODIFIER'**
  String get modifierTitle;

  /// No description provided for @paletteTitle.
  ///
  /// In en, this message translates to:
  /// **'PALETTE'**
  String get paletteTitle;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'LEADERBOARD'**
  String get leaderboard;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settings;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get paused;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'RESUME'**
  String get resume;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'RESTART'**
  String get restart;

  /// No description provided for @nextTrack.
  ///
  /// In en, this message translates to:
  /// **'♪ NEXT TRACK'**
  String get nextTrack;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'MENU'**
  String get menu;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'GAME OVER'**
  String get gameOver;

  /// Game over: this run set a new best score.
  ///
  /// In en, this message translates to:
  /// **'NEW BEST'**
  String get newBest;

  /// Game over stats: best combo, shapes pushed away, shapes broken.
  ///
  /// In en, this message translates to:
  /// **'combo x{combo}   displaced {displaced}   broken {broken}'**
  String gameOverStats(int combo, int displaced, int broken);

  /// Game over: environment, modifier and run length in seconds.
  ///
  /// In en, this message translates to:
  /// **'{environment} · {modifier} · {seconds}s'**
  String gameOverRun(String environment, String modifier, String seconds);

  /// No description provided for @again.
  ///
  /// In en, this message translates to:
  /// **'AGAIN'**
  String get again;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'QUALITY'**
  String get quality;

  /// No description provided for @qualityLow.
  ///
  /// In en, this message translates to:
  /// **'LOW'**
  String get qualityLow;

  /// Graphics quality: medium. Keep short.
  ///
  /// In en, this message translates to:
  /// **'MED'**
  String get qualityMed;

  /// No description provided for @qualityHigh.
  ///
  /// In en, this message translates to:
  /// **'HIGH'**
  String get qualityHigh;

  /// No description provided for @haptics.
  ///
  /// In en, this message translates to:
  /// **'HAPTICS'**
  String get haptics;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'SOUND'**
  String get sound;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'MUSIC'**
  String get music;

  /// No description provided for @debugOverlay.
  ///
  /// In en, this message translates to:
  /// **'DEBUG OVERLAY'**
  String get debugOverlay;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'BACK'**
  String get back;

  /// Toggle chip, keep very short.
  ///
  /// In en, this message translates to:
  /// **'ON'**
  String get on;

  /// Toggle chip, keep very short.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get off;

  /// No description provided for @envVacuum.
  ///
  /// In en, this message translates to:
  /// **'Vacuum'**
  String get envVacuum;

  /// No description provided for @envAir.
  ///
  /// In en, this message translates to:
  /// **'Air'**
  String get envAir;

  /// No description provided for @envWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get envWater;

  /// No description provided for @envPlasma.
  ///
  /// In en, this message translates to:
  /// **'Plasma'**
  String get envPlasma;

  /// No description provided for @modPressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get modPressure;

  /// No description provided for @modImplosion.
  ///
  /// In en, this message translates to:
  /// **'Implosion'**
  String get modImplosion;

  /// No description provided for @modMagnet.
  ///
  /// In en, this message translates to:
  /// **'Magnet'**
  String get modMagnet;

  /// No description provided for @modGravityWell.
  ///
  /// In en, this message translates to:
  /// **'Gravity well'**
  String get modGravityWell;

  /// No description provided for @modChainSpark.
  ///
  /// In en, this message translates to:
  /// **'Chain spark'**
  String get modChainSpark;

  /// No description provided for @paletteCyberpunk.
  ///
  /// In en, this message translates to:
  /// **'Cyberpunk'**
  String get paletteCyberpunk;

  /// No description provided for @paletteVaporwave.
  ///
  /// In en, this message translates to:
  /// **'Vaporwave'**
  String get paletteVaporwave;

  /// No description provided for @paletteAcid.
  ///
  /// In en, this message translates to:
  /// **'Acid'**
  String get paletteAcid;

  /// No description provided for @paletteMono.
  ///
  /// In en, this message translates to:
  /// **'Mono'**
  String get paletteMono;

  /// No description provided for @paletteEmber.
  ///
  /// In en, this message translates to:
  /// **'Ember'**
  String get paletteEmber;

  /// No description provided for @paletteArctic.
  ///
  /// In en, this message translates to:
  /// **'Arctic'**
  String get paletteArctic;

  /// No description provided for @heatTier1.
  ///
  /// In en, this message translates to:
  /// **'HEAT I'**
  String get heatTier1;

  /// No description provided for @heatTier2.
  ///
  /// In en, this message translates to:
  /// **'HEAT II'**
  String get heatTier2;

  /// No description provided for @heatTier3.
  ///
  /// In en, this message translates to:
  /// **'HEAT III'**
  String get heatTier3;

  /// Highest heat tier announced in the middle of the screen.
  ///
  /// In en, this message translates to:
  /// **'OVERDRIVE'**
  String get heatTierOverdrive;

  /// HUD: current score multiplier and combo count.
  ///
  /// In en, this message translates to:
  /// **'x{multiplier}  combo {combo}'**
  String hudCombo(String multiplier, int combo);

  /// HUD: environment name (upper case) and how many shapes escaped of the allowed maximum.
  ///
  /// In en, this message translates to:
  /// **'{environment}  escaped {escaped}/{max}'**
  String hudEscaped(String environment, int escaped, int max);

  /// Main menu button and game over label for the weekly challenge: the same run for every player this week.
  ///
  /// In en, this message translates to:
  /// **'WEEKLY CHALLENGE'**
  String get weekly;

  /// Weekly challenge: whole days until the week ends.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{last day} =1{1 day left} other{{days} days left}}'**
  String weeklyDaysLeft(int days);

  /// Best score in this week's challenge.
  ///
  /// In en, this message translates to:
  /// **'week best · {score}'**
  String weeklyBest(int score);

  /// Button that opens Game Center achievements.
  ///
  /// In en, this message translates to:
  /// **'ACHIEVEMENTS'**
  String get achievements;

  /// Button that opens Game Center challenges (iOS 26+).
  ///
  /// In en, this message translates to:
  /// **'CHALLENGES'**
  String get challenges;

  /// Game over: share the new best score.
  ///
  /// In en, this message translates to:
  /// **'SHARE'**
  String get share;

  /// Text shared with the score card. {link} is the store link.
  ///
  /// In en, this message translates to:
  /// **'My new best in Puff: {score}. Can you beat it? {link}'**
  String shareText(int score, String link);

  /// Settings toggle: weaker flashes and screen shake (accessibility).
  ///
  /// In en, this message translates to:
  /// **'REDUCED FLASHES'**
  String get reducedFlashes;

  /// Seasonal palette offered in December.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get paletteHoliday;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'ca',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'gu',
    'he',
    'hi',
    'hr',
    'hu',
    'id',
    'it',
    'ja',
    'kn',
    'ko',
    'ml',
    'mr',
    'ms',
    'nb',
    'nl',
    'or',
    'pa',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sl',
    'sv',
    'ta',
    'te',
    'th',
    'tr',
    'uk',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
          case 'PT':
            return AppLocalizationsPtPt();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'gu':
      return AppLocalizationsGu();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'kn':
      return AppLocalizationsKn();
    case 'ko':
      return AppLocalizationsKo();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'ms':
      return AppLocalizationsMs();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sv':
      return AppLocalizationsSv();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
