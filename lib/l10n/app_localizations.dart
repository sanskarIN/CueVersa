import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CueVerse'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Aim. Spin. Own the table.'**
  String get tagline;

  /// No description provided for @madeBy.
  ///
  /// In en, this message translates to:
  /// **'Made by the Sanskar'**
  String get madeBy;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice table'**
  String get practice;

  /// No description provided for @versusAi.
  ///
  /// In en, this message translates to:
  /// **'Play vs AI'**
  String get versusAi;

  /// No description provided for @localTwoPlayer.
  ///
  /// In en, this message translates to:
  /// **'Local two-player'**
  String get localTwoPlayer;

  /// No description provided for @onlineComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Online rooms — coming later'**
  String get onlineComingSoon;

  /// No description provided for @challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Open source'**
  String get openSource;

  /// No description provided for @selectMode.
  ///
  /// In en, this message translates to:
  /// **'Select a mode'**
  String get selectMode;

  /// No description provided for @selectRules.
  ///
  /// In en, this message translates to:
  /// **'Select rules'**
  String get selectRules;

  /// No description provided for @eightBall.
  ///
  /// In en, this message translates to:
  /// **'8-ball'**
  String get eightBall;

  /// No description provided for @nineBall.
  ///
  /// In en, this message translates to:
  /// **'9-ball'**
  String get nineBall;

  /// No description provided for @casualRules.
  ///
  /// In en, this message translates to:
  /// **'Casual rules'**
  String get casualRules;

  /// No description provided for @wpaInspired.
  ///
  /// In en, this message translates to:
  /// **'WPA-inspired'**
  String get wpaInspired;

  /// No description provided for @customRules.
  ///
  /// In en, this message translates to:
  /// **'Custom rules'**
  String get customRules;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @expert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get expert;

  /// No description provided for @master.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get master;

  /// No description provided for @gameTable.
  ///
  /// In en, this message translates to:
  /// **'Game table'**
  String get gameTable;

  /// No description provided for @playerOne.
  ///
  /// In en, this message translates to:
  /// **'Player 1'**
  String get playerOne;

  /// No description provided for @playerTwo.
  ///
  /// In en, this message translates to:
  /// **'Player 2'**
  String get playerTwo;

  /// No description provided for @aiPlayer.
  ///
  /// In en, this message translates to:
  /// **'CueVerse AI'**
  String get aiPlayer;

  /// No description provided for @yourTurn.
  ///
  /// In en, this message translates to:
  /// **'Your turn'**
  String get yourTurn;

  /// No description provided for @aimHint.
  ///
  /// In en, this message translates to:
  /// **'Drag on the table to aim. Pull the power control, then release to shoot.'**
  String get aimHint;

  /// No description provided for @power.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get power;

  /// No description provided for @spin.
  ///
  /// In en, this message translates to:
  /// **'Spin'**
  String get spin;

  /// No description provided for @shoot.
  ///
  /// In en, this message translates to:
  /// **'Shoot'**
  String get shoot;

  /// No description provided for @resetRack.
  ///
  /// In en, this message translates to:
  /// **'Reset rack'**
  String get resetRack;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @quitMatch.
  ///
  /// In en, this message translates to:
  /// **'Quit match'**
  String get quitMatch;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @winner.
  ///
  /// In en, this message translates to:
  /// **'Winner'**
  String get winner;

  /// No description provided for @foul.
  ///
  /// In en, this message translates to:
  /// **'Foul'**
  String get foul;

  /// No description provided for @scratch.
  ///
  /// In en, this message translates to:
  /// **'Scratch — ball in hand'**
  String get scratch;

  /// No description provided for @breakShot.
  ///
  /// In en, this message translates to:
  /// **'Break shot'**
  String get breakShot;

  /// No description provided for @openTable.
  ///
  /// In en, this message translates to:
  /// **'Open table'**
  String get openTable;

  /// No description provided for @solids.
  ///
  /// In en, this message translates to:
  /// **'Solids'**
  String get solids;

  /// No description provided for @stripes.
  ///
  /// In en, this message translates to:
  /// **'Stripes'**
  String get stripes;

  /// No description provided for @ballInHand.
  ///
  /// In en, this message translates to:
  /// **'Ball in hand'**
  String get ballInHand;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsGameplay.
  ///
  /// In en, this message translates to:
  /// **'Gameplay'**
  String get settingsGameplay;

  /// No description provided for @settingsControls.
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get settingsControls;

  /// No description provided for @settingsSound.
  ///
  /// In en, this message translates to:
  /// **'Sound & haptics'**
  String get settingsSound;

  /// No description provided for @settingsAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingsAccessibility;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data & storage'**
  String get settingsData;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get settingsPerformance;

  /// No description provided for @settingsDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer options'**
  String get settingsDeveloper;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get highContrast;

  /// No description provided for @reducedMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduced motion'**
  String get reducedMotion;

  /// No description provided for @leftHanded.
  ///
  /// In en, this message translates to:
  /// **'Left-handed controls'**
  String get leftHanded;

  /// No description provided for @haptics.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get haptics;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get soundEffects;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @aimSensitivity.
  ///
  /// In en, this message translates to:
  /// **'Aim sensitivity'**
  String get aimSensitivity;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @restoreDefaults.
  ///
  /// In en, this message translates to:
  /// **'Restore defaults'**
  String get restoreDefaults;

  /// No description provided for @deleteLocalData.
  ///
  /// In en, this message translates to:
  /// **'Delete all local data'**
  String get deleteLocalData;

  /// No description provided for @deleteDataWarning.
  ///
  /// In en, this message translates to:
  /// **'This removes settings, progress, and local statistics from this device.'**
  String get deleteDataWarning;

  /// No description provided for @supportProject.
  ///
  /// In en, this message translates to:
  /// **'Support this project — Buy Me a Coffee'**
  String get supportProject;

  /// No description provided for @supportLabel.
  ///
  /// In en, this message translates to:
  /// **'Support Sanskar on Buy Me a Coffee'**
  String get supportLabel;

  /// No description provided for @supportDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Support is optional and does not unlock gameplay or guarantee priority.'**
  String get supportDisclaimer;

  /// No description provided for @openExternalLink.
  ///
  /// In en, this message translates to:
  /// **'Opens an external link'**
  String get openExternalLink;

  /// No description provided for @linkFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link. Please try again.'**
  String get linkFailed;

  /// No description provided for @repository.
  ///
  /// In en, this message translates to:
  /// **'Source repository'**
  String get repository;

  /// No description provided for @creatorProfile.
  ///
  /// In en, this message translates to:
  /// **'Creator GitHub profile'**
  String get creatorProfile;

  /// No description provided for @supportEmail.
  ///
  /// In en, this message translates to:
  /// **'Support email'**
  String get supportEmail;

  /// No description provided for @businessEmail.
  ///
  /// In en, this message translates to:
  /// **'Project and business email'**
  String get businessEmail;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get terms;

  /// No description provided for @thirdPartyNotices.
  ///
  /// In en, this message translates to:
  /// **'Third-party notices'**
  String get thirdPartyNotices;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @developerUnlockProgress.
  ///
  /// In en, this message translates to:
  /// **'{count} more taps to unlock developer options'**
  String developerUnlockProgress(int count);

  /// No description provided for @developerUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Developer options unlocked'**
  String get developerUnlocked;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @offlineOnly.
  ///
  /// In en, this message translates to:
  /// **'Works offline'**
  String get offlineOnly;

  /// No description provided for @dailyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Daily challenge'**
  String get dailyChallenge;

  /// No description provided for @weeklyMissions.
  ///
  /// In en, this message translates to:
  /// **'Weekly missions'**
  String get weeklyMissions;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String level(int level);

  /// No description provided for @xpProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {target} XP'**
  String xpProgress(int current, int target);

  /// No description provided for @matchesPlayed.
  ///
  /// In en, this message translates to:
  /// **'Matches played'**
  String get matchesPlayed;

  /// No description provided for @wins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get wins;

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get bestStreak;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Shot accuracy'**
  String get accuracy;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No matches recorded yet.'**
  String get noHistory;

  /// No description provided for @tutorial.
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorial;

  /// No description provided for @rulesGuide.
  ///
  /// In en, this message translates to:
  /// **'Rules guide'**
  String get rulesGuide;

  /// No description provided for @cosmetics.
  ///
  /// In en, this message translates to:
  /// **'Cosmetics'**
  String get cosmetics;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @equipped.
  ///
  /// In en, this message translates to:
  /// **'Equipped'**
  String get equipped;

  /// No description provided for @freeAndFair.
  ///
  /// In en, this message translates to:
  /// **'Cosmetic only — ranked physics stay equal'**
  String get freeAndFair;

  /// No description provided for @notOfficialRules.
  ///
  /// In en, this message translates to:
  /// **'This profile is inspired by common rules and is not presented as an official tournament ruling.'**
  String get notOfficialRules;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
