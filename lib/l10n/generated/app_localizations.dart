import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('pt')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'NumBloom'**
  String get appName;

  /// No description provided for @slogan.
  ///
  /// In en, this message translates to:
  /// **'Let Numbers Bloom.'**
  String get slogan;

  /// No description provided for @levelEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get levelEasy;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @levelHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get levelHard;

  /// No description provided for @resultCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct! Your garden grows.'**
  String get resultCorrect;

  /// No description provided for @resultWrong.
  ///
  /// In en, this message translates to:
  /// **'Not quite: {left} ≠ {right}'**
  String resultWrong(String left, String right);

  /// No description provided for @errEmpty.
  ///
  /// In en, this message translates to:
  /// **'Build an expression first.'**
  String get errEmpty;

  /// No description provided for @errMissingEquals.
  ///
  /// In en, this message translates to:
  /// **'The expression needs an equals sign (=).'**
  String get errMissingEquals;

  /// No description provided for @errMultipleEquals.
  ///
  /// In en, this message translates to:
  /// **'Use only one equals sign (=).'**
  String get errMultipleEquals;

  /// No description provided for @errUnexpectedToken.
  ///
  /// In en, this message translates to:
  /// **'Something is out of place in the expression.'**
  String get errUnexpectedToken;

  /// No description provided for @errUnexpectedEnd.
  ///
  /// In en, this message translates to:
  /// **'The expression is incomplete.'**
  String get errUnexpectedEnd;

  /// No description provided for @errUnbalanced.
  ///
  /// In en, this message translates to:
  /// **'Parentheses or brackets are not balanced.'**
  String get errUnbalanced;

  /// No description provided for @errOperatorNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'That operator is not available at this level.'**
  String get errOperatorNotAllowed;

  /// No description provided for @errDivisionByZero.
  ///
  /// In en, this message translates to:
  /// **'Division by zero is not allowed.'**
  String get errDivisionByZero;

  /// No description provided for @errNonIntegerDivision.
  ///
  /// In en, this message translates to:
  /// **'Only exact (integer) divisions are allowed at this level.'**
  String get errNonIntegerDivision;

  /// No description provided for @errNegativeSqrt.
  ///
  /// In en, this message translates to:
  /// **'Square root of a negative number.'**
  String get errNegativeSqrt;

  /// No description provided for @errNonIntegerRoot.
  ///
  /// In en, this message translates to:
  /// **'Roots must be exact at this level.'**
  String get errNonIntegerRoot;

  /// No description provided for @errInvalidFactorial.
  ///
  /// In en, this message translates to:
  /// **'Factorial needs a non-negative integer.'**
  String get errInvalidFactorial;

  /// No description provided for @errNonIntegerResult.
  ///
  /// In en, this message translates to:
  /// **'Intermediate results must be integers at this level.'**
  String get errNonIntegerResult;

  /// No description provided for @errOverflow.
  ///
  /// In en, this message translates to:
  /// **'That number got too big.'**
  String get errOverflow;

  /// No description provided for @errInvalidPower.
  ///
  /// In en, this message translates to:
  /// **'Invalid power.'**
  String get errInvalidPower;

  /// No description provided for @titleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get titleSignIn;

  /// No description provided for @titleSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get titleSignUp;

  /// No description provided for @titleGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get titleGoogle;

  /// No description provided for @groupCredits.
  ///
  /// In en, this message translates to:
  /// **'Made by {members}'**
  String groupCredits(String members);

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get languagePortuguese;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @navGame.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get navGame;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get navHelp;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming in the next step.'**
  String get comingSoon;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Device'**
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

  /// No description provided for @settingsFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get settingsFontSize;

  /// No description provided for @settingsFontPreview.
  ///
  /// In en, this message translates to:
  /// **'A garden grows with every sum: 2 + 3 = 5.'**
  String get settingsFontPreview;

  /// No description provided for @settingsFontFamily.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get settingsFontFamily;

  /// No description provided for @settingsSeedColor.
  ///
  /// In en, this message translates to:
  /// **'Theme color'**
  String get settingsSeedColor;

  /// No description provided for @settingsCustomColor.
  ///
  /// In en, this message translates to:
  /// **'Custom color'**
  String get settingsCustomColor;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get settingsSound;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String settingsSignedInAs(String email);

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'How to play'**
  String get helpTitle;

  /// No description provided for @helpGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get helpGoalTitle;

  /// No description provided for @helpHowTitle.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get helpHowTitle;

  /// No description provided for @helpLevelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Levels and operators'**
  String get helpLevelsTitle;

  /// No description provided for @helpRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get helpRulesTitle;

  /// No description provided for @helpGardenTitle.
  ///
  /// In en, this message translates to:
  /// **'Your garden'**
  String get helpGardenTitle;

  /// No description provided for @helpGardenBody.
  ///
  /// In en, this message translates to:
  /// **'Every solved number plants something new in your garden, and plants grow as you keep solving. Skipped numbers do not count.'**
  String get helpGardenBody;

  /// No description provided for @themeSwitchToDark.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark mode'**
  String get themeSwitchToDark;

  /// No description provided for @themeSwitchToLight.
  ///
  /// In en, this message translates to:
  /// **'Switch to light mode'**
  String get themeSwitchToLight;

  /// No description provided for @soundTurnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn sound effects on'**
  String get soundTurnOn;

  /// No description provided for @soundTurnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn sound effects off'**
  String get soundTurnOff;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your data.'**
  String get loadError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @gameNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get gameNumberLabel;

  /// No description provided for @gameLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get gameLevelLabel;

  /// No description provided for @gameScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get gameScore;

  /// No description provided for @gameFormulaTitle.
  ///
  /// In en, this message translates to:
  /// **'Your formula'**
  String get gameFormulaTitle;

  /// No description provided for @gameFormulaEmpty.
  ///
  /// In en, this message translates to:
  /// **'Place operators between the digits to build your formula.'**
  String get gameFormulaEmpty;

  /// No description provided for @gameOperators.
  ///
  /// In en, this message translates to:
  /// **'Operators'**
  String get gameOperators;

  /// No description provided for @gameCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get gameCheck;

  /// No description provided for @gameClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get gameClear;

  /// No description provided for @gameUndo.
  ///
  /// In en, this message translates to:
  /// **'Remove last'**
  String get gameUndo;

  /// No description provided for @gameSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get gameSkip;

  /// No description provided for @gameNext.
  ///
  /// In en, this message translates to:
  /// **'Next number'**
  String get gameNext;

  /// No description provided for @gameSlotLabel.
  ///
  /// In en, this message translates to:
  /// **'Gap {index}'**
  String gameSlotLabel(int index);

  /// No description provided for @gameTapGapHint.
  ///
  /// In en, this message translates to:
  /// **'Now tap a gap in the number, or drag the piece there.'**
  String get gameTapGapHint;

  /// No description provided for @gameCorrectPoints.
  ///
  /// In en, this message translates to:
  /// **'+{points} points'**
  String gameCorrectPoints(int points);

  /// No description provided for @gameSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving your progress…'**
  String get gameSaving;

  /// No description provided for @gameSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save your progress. Check your connection.'**
  String get gameSaveError;

  /// No description provided for @gameAllSolved.
  ///
  /// In en, this message translates to:
  /// **'You solved every number at this level! Try another level.'**
  String get gameAllSolved;

  /// No description provided for @progressSolved.
  ///
  /// In en, this message translates to:
  /// **'Solved'**
  String get progressSolved;

  /// No description provided for @progressCompletion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get progressCompletion;

  /// No description provided for @progressByLevel.
  ///
  /// In en, this message translates to:
  /// **'By level'**
  String get progressByLevel;

  /// No description provided for @progressGardenTitle.
  ///
  /// In en, this message translates to:
  /// **'Your garden'**
  String get progressGardenTitle;

  /// No description provided for @progressGardenLabel.
  ///
  /// In en, this message translates to:
  /// **'Garden with {count} plants'**
  String progressGardenLabel(int count);

  /// No description provided for @progressRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent solutions'**
  String get progressRecent;

  /// No description provided for @progressNoSolutions.
  ///
  /// In en, this message translates to:
  /// **'Solve your first number to plant your first seed!'**
  String get progressNoSolutions;

  /// No description provided for @progressLevelCount.
  ///
  /// In en, this message translates to:
  /// **'{solved} of {total}'**
  String progressLevelCount(int solved, int total);

  /// No description provided for @musicTurnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn music on'**
  String get musicTurnOn;

  /// No description provided for @musicTurnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn music off'**
  String get musicTurnOff;

  /// No description provided for @settingsMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get settingsMusic;

  /// No description provided for @settingsMusicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle background music. Off by default.'**
  String get settingsMusicSubtitle;

  /// No description provided for @settingsEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get settingsEffects;

  /// No description provided for @settingsEffectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clicks and answer sounds. Off by default.'**
  String get settingsEffectsSubtitle;

  /// No description provided for @helpGoalBody.
  ///
  /// In en, this message translates to:
  /// **'You get a four-digit number. Place operators between its digits, in order, so that both sides of the equals sign give the same result.'**
  String get helpGoalBody;

  /// No description provided for @helpExample.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get helpExample;

  /// No description provided for @helpExampleCaption.
  ///
  /// In en, this message translates to:
  /// **'The number 8131 becomes √(8+1) = 3**1, because 3 = 3.'**
  String get helpExampleCaption;

  /// No description provided for @helpStep1.
  ///
  /// In en, this message translates to:
  /// **'Pick a level. Harder levels have fewer operators and give more points.'**
  String get helpStep1;

  /// No description provided for @helpStep2.
  ///
  /// In en, this message translates to:
  /// **'Tap an operator, then tap a gap in the number. You can also hold and drag it there.'**
  String get helpStep2;

  /// No description provided for @helpStep3.
  ///
  /// In en, this message translates to:
  /// **'Tap a placed piece to remove it. “Remove last” and “Clear” help too.'**
  String get helpStep3;

  /// No description provided for @helpStep4.
  ///
  /// In en, this message translates to:
  /// **'Press Check. The pieces fly back to their buttons and your answer is tested.'**
  String get helpStep4;

  /// No description provided for @helpStep5.
  ///
  /// In en, this message translates to:
  /// **'Correct answers earn points and make your garden grow. Stuck? Press Skip.'**
  String get helpStep5;

  /// No description provided for @helpRule1.
  ///
  /// In en, this message translates to:
  /// **'Digits side by side form one number: 1 and 4 become 14.'**
  String get helpRule1;

  /// No description provided for @helpRule2.
  ///
  /// In en, this message translates to:
  /// **'Use exactly one equals sign. It starts between the 2nd and 3rd digits and can be moved.'**
  String get helpRule2;

  /// No description provided for @helpRule3.
  ///
  /// In en, this message translates to:
  /// **'Only Easy accepts non-integer results, like 5/2. In other levels every division and root must be exact.'**
  String get helpRule3;

  /// No description provided for @helpRule4.
  ///
  /// In en, this message translates to:
  /// **'Factorial (!) needs a whole number that is zero or more.'**
  String get helpRule4;

  /// No description provided for @helpLevelPoints.
  ///
  /// In en, this message translates to:
  /// **'{points} points per number'**
  String helpLevelPoints(int points);

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authGoogleButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get authGoogleButton;

  /// No description provided for @authResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authResetTitle;

  /// No description provided for @authResetSend.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get authResetSend;

  /// No description provided for @opTipAdd.
  ///
  /// In en, this message translates to:
  /// **'Addition: 2 + 3 = 5'**
  String get opTipAdd;

  /// No description provided for @opTipSubtract.
  ///
  /// In en, this message translates to:
  /// **'Subtraction: 5 − 2 = 3'**
  String get opTipSubtract;

  /// No description provided for @opTipMultiply.
  ///
  /// In en, this message translates to:
  /// **'Multiplication: 2 × 3 = 6'**
  String get opTipMultiply;

  /// No description provided for @opTipDivide.
  ///
  /// In en, this message translates to:
  /// **'Division: 6 ÷ 3 = 2'**
  String get opTipDivide;

  /// No description provided for @opTipParenOpen.
  ///
  /// In en, this message translates to:
  /// **'Open parenthesis: groups what comes next'**
  String get opTipParenOpen;

  /// No description provided for @opTipParenClose.
  ///
  /// In en, this message translates to:
  /// **'Close parenthesis: ends the group'**
  String get opTipParenClose;

  /// No description provided for @opTipSqrt.
  ///
  /// In en, this message translates to:
  /// **'Square root: √9 = 3'**
  String get opTipSqrt;

  /// No description provided for @opTipCbrt.
  ///
  /// In en, this message translates to:
  /// **'Cube root: ∛8 = 2'**
  String get opTipCbrt;

  /// No description provided for @opTipFactorial.
  ///
  /// In en, this message translates to:
  /// **'Factorial: 4! = 4 × 3 × 2 × 1 = 24'**
  String get opTipFactorial;

  /// No description provided for @opTipPower.
  ///
  /// In en, this message translates to:
  /// **'Power (exponent): 2 ** 3 = 8'**
  String get opTipPower;

  /// No description provided for @opTipAbs.
  ///
  /// In en, this message translates to:
  /// **'Absolute value (modulus): |−5| = 5. One bar opens, the next closes'**
  String get opTipAbs;

  /// No description provided for @opTipFloorOpen.
  ///
  /// In en, this message translates to:
  /// **'Floor, opening: ⌊x⌋ is the largest integer not above x'**
  String get opTipFloorOpen;

  /// No description provided for @opTipFloorClose.
  ///
  /// In en, this message translates to:
  /// **'Floor, closing'**
  String get opTipFloorClose;

  /// No description provided for @opTipCeilOpen.
  ///
  /// In en, this message translates to:
  /// **'Ceiling, opening: ⌈x⌉ is the smallest integer not below x'**
  String get opTipCeilOpen;

  /// No description provided for @opTipCeilClose.
  ///
  /// In en, this message translates to:
  /// **'Ceiling, closing'**
  String get opTipCeilClose;

  /// No description provided for @opTipEquals.
  ///
  /// In en, this message translates to:
  /// **'Equals sign: both sides must give the same result'**
  String get opTipEquals;

  /// No description provided for @gameTileHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to move · tap to remove'**
  String get gameTileHint;

  /// No description provided for @firebaseInitError.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to Firebase. Check the project configuration (flutterfire configure) and your internet connection.'**
  String get firebaseInitError;
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
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
