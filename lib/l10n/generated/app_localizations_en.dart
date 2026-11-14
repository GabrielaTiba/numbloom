// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'NumBloom';

  @override
  String get slogan => 'Let Numbers Bloom.';

  @override
  String get levelEasy => 'Easy';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get levelHard => 'Hard';

  @override
  String get resultCorrect => 'Correct! Your garden grows.';

  @override
  String resultWrong(String left, String right) {
    return 'Not quite: $left ≠ $right';
  }

  @override
  String get errEmpty => 'Build an expression first.';

  @override
  String get errMissingEquals => 'The expression needs an equals sign (=).';

  @override
  String get errMultipleEquals => 'Use only one equals sign (=).';

  @override
  String get errUnexpectedToken =>
      'Something is out of place in the expression.';

  @override
  String get errUnexpectedEnd => 'The expression is incomplete.';

  @override
  String get errUnbalanced => 'Parentheses or brackets are not balanced.';

  @override
  String get errOperatorNotAllowed =>
      'That operator is not available at this level.';

  @override
  String get errDivisionByZero => 'Division by zero is not allowed.';

  @override
  String get errNonIntegerDivision =>
      'Only exact (integer) divisions are allowed at this level.';

  @override
  String get errNegativeSqrt => 'Square root of a negative number.';

  @override
  String get errNonIntegerRoot => 'Roots must be exact at this level.';

  @override
  String get errInvalidFactorial => 'Factorial needs a non-negative integer.';

  @override
  String get errNonIntegerResult =>
      'Intermediate results must be integers at this level.';

  @override
  String get errOverflow => 'That number got too big.';

  @override
  String get errInvalidPower => 'Invalid power.';

  @override
  String get titleSignIn => 'Sign in';

  @override
  String get titleSignUp => 'Sign up';

  @override
  String get titleGoogle => 'Google';

  @override
  String groupCredits(String members) {
    return 'Made by $members';
  }

  @override
  String get languagePortuguese => 'Portuguese';

  @override
  String get languageEnglish => 'English';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get navGame => 'Play';

  @override
  String get navProgress => 'Progress';

  @override
  String get navSettings => 'Settings';

  @override
  String get navHelp => 'Help';

  @override
  String get comingSoon => 'Coming in the next step.';

  @override
  String get back => 'Back';

  @override
  String get close => 'Close';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'Device';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsFontSize => 'Font size';

  @override
  String get settingsFontPreview => 'A garden grows with every sum: 2 + 3 = 5.';

  @override
  String get settingsFontFamily => 'Font';

  @override
  String get settingsSeedColor => 'Theme color';

  @override
  String get settingsCustomColor => 'Custom color';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsSound => 'Sound';

  @override
  String get settingsAccount => 'Account';

  @override
  String settingsSignedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get helpTitle => 'How to play';

  @override
  String get helpGoalTitle => 'Goal';

  @override
  String get helpHowTitle => 'Playing';

  @override
  String get helpLevelsTitle => 'Levels and operators';

  @override
  String get helpRulesTitle => 'Rules';

  @override
  String get helpGardenTitle => 'Your garden';

  @override
  String get helpGardenBody =>
      'Every solved number plants something new in your garden, and plants grow as you keep solving. Skipped numbers do not count.';

  @override
  String get themeSwitchToDark => 'Switch to dark mode';

  @override
  String get themeSwitchToLight => 'Switch to light mode';

  @override
  String get soundTurnOn => 'Turn sound effects on';

  @override
  String get soundTurnOff => 'Turn sound effects off';

  @override
  String get loading => 'Loading…';

  @override
  String get loadError => 'Could not load your data.';

  @override
  String get retry => 'Try again';

  @override
  String get gameNumberLabel => 'Number';

  @override
  String get gameLevelLabel => 'Level';

  @override
  String get gameScore => 'Score';

  @override
  String get gameFormulaTitle => 'Your formula';

  @override
  String get gameFormulaEmpty =>
      'Place operators between the digits to build your formula.';

  @override
  String get gameOperators => 'Operators';

  @override
  String get gameCheck => 'Check';

  @override
  String get gameClear => 'Clear';

  @override
  String get gameUndo => 'Remove last';

  @override
  String get gameSkip => 'Skip';

  @override
  String get gameNext => 'Next number';

  @override
  String gameSlotLabel(int index) {
    return 'Gap $index';
  }

  @override
  String get gameTapGapHint =>
      'Now tap a gap in the number, or drag the piece there.';

  @override
  String gameCorrectPoints(int points) {
    return '+$points points';
  }

  @override
  String get gameSaving => 'Saving your progress…';

  @override
  String get gameSaveError =>
      'Could not save your progress. Check your connection.';

  @override
  String get gameAllSolved =>
      'You solved every number at this level! Try another level.';

  @override
  String get progressSolved => 'Solved';

  @override
  String get progressCompletion => 'Completion';

  @override
  String get progressByLevel => 'By level';

  @override
  String get progressGardenTitle => 'Your garden';

  @override
  String progressGardenLabel(int count) {
    return 'Garden with $count plants';
  }

  @override
  String get progressRecent => 'Recent solutions';

  @override
  String get progressNoSolutions =>
      'Solve your first number to plant your first seed!';

  @override
  String progressLevelCount(int solved, int total) {
    return '$solved of $total';
  }

  @override
  String get musicTurnOn => 'Turn music on';

  @override
  String get musicTurnOff => 'Turn music off';

  @override
  String get settingsMusic => 'Music';

  @override
  String get settingsMusicSubtitle =>
      'Gentle background music. Off by default.';

  @override
  String get settingsEffects => 'Sound effects';

  @override
  String get settingsEffectsSubtitle =>
      'Clicks and answer sounds. Off by default.';

  @override
  String get helpGoalBody =>
      'You get a four-digit number. Place operators between its digits, in order, so that both sides of the equals sign give the same result.';

  @override
  String get helpExample => 'Example';

  @override
  String get helpExampleCaption =>
      'The number 8131 becomes √(8+1) = 3**1, because 3 = 3.';

  @override
  String get helpStep1 =>
      'Pick a level. Harder levels have fewer operators and give more points.';

  @override
  String get helpStep2 =>
      'Tap an operator, then tap a gap in the number. You can also hold and drag it there.';

  @override
  String get helpStep3 =>
      'Tap a placed piece to remove it. “Remove last” and “Clear” help too.';

  @override
  String get helpStep4 =>
      'Press Check. The pieces fly back to their buttons and your answer is tested.';

  @override
  String get helpStep5 =>
      'Correct answers earn points and make your garden grow. Stuck? Press Skip.';

  @override
  String get helpRule1 =>
      'Digits side by side form one number: 1 and 4 become 14.';

  @override
  String get helpRule2 =>
      'Use exactly one equals sign. It starts between the 2nd and 3rd digits and can be moved.';

  @override
  String get helpRule3 =>
      'Only Easy accepts non-integer results, like 5/2. In other levels every division and root must be exact.';

  @override
  String get helpRule4 =>
      'Factorial (!) needs a whole number that is zero or more.';

  @override
  String helpLevelPoints(int points) {
    return '$points points per number';
  }

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authGoogleButton => 'Sign in with Google';

  @override
  String get authResetTitle => 'Reset password';

  @override
  String get authResetSend => 'Send reset link';

  @override
  String get opTipAdd => 'Addition: 2 + 3 = 5';

  @override
  String get opTipSubtract => 'Subtraction: 5 − 2 = 3';

  @override
  String get opTipMultiply => 'Multiplication: 2 × 3 = 6';

  @override
  String get opTipDivide => 'Division: 6 ÷ 3 = 2';

  @override
  String get opTipParenOpen => 'Open parenthesis: groups what comes next';

  @override
  String get opTipParenClose => 'Close parenthesis: ends the group';

  @override
  String get opTipSqrt => 'Square root: √9 = 3';

  @override
  String get opTipCbrt => 'Cube root: ∛8 = 2';

  @override
  String get opTipFactorial => 'Factorial: 4! = 4 × 3 × 2 × 1 = 24';

  @override
  String get opTipPower => 'Power (exponent): 2 ** 3 = 8';

  @override
  String get opTipAbs =>
      'Absolute value (modulus): |−5| = 5. One bar opens, the next closes';

  @override
  String get opTipFloorOpen =>
      'Floor, opening: ⌊x⌋ is the largest integer not above x';

  @override
  String get opTipFloorClose => 'Floor, closing';

  @override
  String get opTipCeilOpen =>
      'Ceiling, opening: ⌈x⌉ is the smallest integer not below x';

  @override
  String get opTipCeilClose => 'Ceiling, closing';

  @override
  String get opTipEquals => 'Equals sign: both sides must give the same result';

  @override
  String get gameTileHint => 'Drag to move · tap to remove';

  @override
  String get firebaseInitError =>
      'Could not connect to Firebase. Check the project configuration (flutterfire configure) and your internet connection.';
}
