import '../../l10n/generated/app_localizations.dart';
import 'operator_kind.dart';

extension OperatorKindL10n on OperatorKind {
  /// Nome do operador + exemplo, para as dicas ao passar o mouse.
  String tooltip(AppLocalizations l) {
    switch (this) {
      case OperatorKind.add:
        return l.opTipAdd;
      case OperatorKind.subtract:
        return l.opTipSubtract;
      case OperatorKind.multiply:
        return l.opTipMultiply;
      case OperatorKind.divide:
        return l.opTipDivide;
      case OperatorKind.parenOpen:
        return l.opTipParenOpen;
      case OperatorKind.parenClose:
        return l.opTipParenClose;
      case OperatorKind.sqrt:
        return l.opTipSqrt;
      case OperatorKind.cbrt:
        return l.opTipCbrt;
      case OperatorKind.factorial:
        return l.opTipFactorial;
      case OperatorKind.power:
        return l.opTipPower;
      case OperatorKind.absOpen:
      case OperatorKind.absClose:
        return l.opTipAbs;
      case OperatorKind.floorOpen:
        return l.opTipFloorOpen;
      case OperatorKind.floorClose:
        return l.opTipFloorClose;
      case OperatorKind.ceilOpen:
        return l.opTipCeilOpen;
      case OperatorKind.ceilClose:
        return l.opTipCeilClose;
      case OperatorKind.equals:
        return l.opTipEquals;
    }
  }
}