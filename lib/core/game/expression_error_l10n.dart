import '../../l10n/generated/app_localizations.dart';
import 'expression_parser.dart';

/// Traduz códigos de erro do avaliador (sem texto fixo no serviço).
extension ExpressionErrorL10n on ExpressionErrorCode {
  String localized(AppLocalizations l) {
    switch (this) {
      case ExpressionErrorCode.empty:
        return l.errEmpty;
      case ExpressionErrorCode.missingEquals:
        return l.errMissingEquals;
      case ExpressionErrorCode.multipleEquals:
        return l.errMultipleEquals;
      case ExpressionErrorCode.unexpectedToken:
        return l.errUnexpectedToken;
      case ExpressionErrorCode.unexpectedEnd:
        return l.errUnexpectedEnd;
      case ExpressionErrorCode.unbalanced:
        return l.errUnbalanced;
      case ExpressionErrorCode.operatorNotAllowed:
        return l.errOperatorNotAllowed;
      case ExpressionErrorCode.divisionByZero:
        return l.errDivisionByZero;
      case ExpressionErrorCode.nonIntegerDivision:
        return l.errNonIntegerDivision;
      case ExpressionErrorCode.negativeSqrt:
        return l.errNegativeSqrt;
      case ExpressionErrorCode.nonIntegerRoot:
        return l.errNonIntegerRoot;
      case ExpressionErrorCode.invalidFactorial:
        return l.errInvalidFactorial;
      case ExpressionErrorCode.nonIntegerResult:
        return l.errNonIntegerResult;
      case ExpressionErrorCode.overflow:
        return l.errOverflow;
      case ExpressionErrorCode.invalidPower:
        return l.errInvalidPower;
    }
  }
}