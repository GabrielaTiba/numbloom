import '../../l10n/generated/app_localizations.dart';
import 'game_level.dart';

extension GameLevelL10n on GameLevel {
  String label(AppLocalizations l) {
    switch (this) {
      case GameLevel.easy:
        return l.levelEasy;
      case GameLevel.intermediate:
        return l.levelIntermediate;
      case GameLevel.advanced:
        return l.levelAdvanced;
      case GameLevel.hard:
        return l.levelHard;
    }
  }
}