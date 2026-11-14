import 'package:flutter/material.dart';

import '../../../core/game/game_level.dart';
import '../../../core/game/operator_kind.dart';
import '../../../shared/widgets/math_tile.dart';
import 'operator_draggable.dart';
import 'operator_tooltip.dart';

/// Operadores disponíveis no nível. Toque seleciona (depois toque num
/// espaço); também dá para arrastar. Ao passar o mouse, uma dica diz o que
/// cada operador faz. O "=" é único: enquanto estiver na expressão, o botão
/// fica "vazio".
class OperatorPalette extends StatelessWidget {
  const OperatorPalette({
    super.key,
    required this.level,
    required this.selected,
    required this.equalsPlaced,
    required this.enabled,
    required this.paletteKey,
    required this.onTap,
    required this.onDragStart,
    required this.onDragEnd,
  });

  final GameLevel level;
  final OperatorKind? selected;
  final bool equalsPlaced;
  final bool enabled;
  final GlobalKey Function(OperatorKind op) paletteKey;
  final ValueChanged<OperatorKind> onTap;

  /// Início/fim de um arrasto (a tela destaca os espaços enquanto arrasta).
  final ValueChanged<OperatorKind> onDragStart;
  final VoidCallback onDragEnd;

  /// A barra "|" é uma peça só (absClose não aparece na paleta).
  static List<OperatorKind> opsFor(GameLevel level) => [
        for (final op in OperatorKind.values)
          if (op != OperatorKind.absClose && level.allows(op)) op,
      ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        for (final op in opsFor(level))
          _PaletteTile(
            op: op,
            tileKey: paletteKey(op),
            selected: selected == op,
            used: op == OperatorKind.equals && equalsPlaced,
            enabled: enabled,
            onTap: () => onTap(op),
            onDragStart: () => onDragStart(op),
            onDragEnd: onDragEnd,
          ),
      ],
    );
  }
}

class _PaletteTile extends StatelessWidget {
  const _PaletteTile({
    required this.op,
    required this.tileKey,
    required this.selected,
    required this.used,
    required this.enabled,
    required this.onTap,
    required this.onDragStart,
    required this.onDragEnd,
  });

  final OperatorKind op;
  final GlobalKey tileKey;
  final bool selected;
  final bool used;
  final bool enabled;
  final VoidCallback onTap;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    final canUse = enabled && !used;
    Widget tile = MathTile(
      key: tileKey,
      label: op.symbol,
      selected: selected,
      ghost: used,
      onTap: canUse ? onTap : null,
    );
    if (canUse) {
      tile = OperatorDraggable(
        data: OperatorDrag(op),
        feedbackLabel: op.symbol,
        onDragStarted: onDragStart,
        onDragEnd: onDragEnd,
        child: tile,
      );
    }
    return OperatorTooltip(op: op, child: tile);
  }
}