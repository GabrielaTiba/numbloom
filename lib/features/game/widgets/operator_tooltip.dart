import 'package:flutter/material.dart';

import '../../../core/game/operator_kind.dart';
import '../../../core/game/operator_kind_l10n.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Dica com o nome do operador e um exemplo, ao passar o mouse.
/// No celular (toque) a dica fica desligada para não competir com o arrastar.
class OperatorTooltip extends StatelessWidget {
  const OperatorTooltip({
    super.key,
    required this.op,
    required this.child,
    this.extra,
  });

  final OperatorKind op;
  final Widget child;

  /// Linha adicional (ex.: "Arraste para mover · toque para remover").
  final String? extra;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final platform = Theme.of(context).platform;
    final touch = platform == TargetPlatform.android ||
        platform == TargetPlatform.iOS ||
        platform == TargetPlatform.fuchsia;
    return Tooltip(
      message: extra == null ? op.tooltip(l) : '${op.tooltip(l)}\n$extra',
      triggerMode: touch ? TooltipTriggerMode.manual : TooltipTriggerMode.longPress,
      child: child,
    );
  }
}