import 'package:flutter/material.dart';

import '../../../core/game/operator_kind.dart';
import '../../../core/theme/pixel_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/expression_model.dart';
import '../../../shared/widgets/math_tile.dart';
import '../../../shared/widgets/pixel_box.dart';
import '../../../shared/widgets/pixel_pressable.dart';
import 'operator_draggable.dart';
import 'operator_tooltip.dart';

/// Os 4 dígitos com os espaços para operadores. Em CADA espaço há pontos de
/// inserção antes, entre e depois das peças já colocadas, então dá para
/// colocar um operador à esquerda ou à direita de qualquer outro.
///  * toque no ponto de inserção: coloca o operador selecionado;
///  * soltar uma peça arrastada: coloca ali (da paleta) ou MOVE (da expressão);
///  * tocar numa peça colocada a remove; arrastá-la para fora também.
class ExpressionBoard extends StatelessWidget {
  const ExpressionBoard({
    super.key,
    required this.digits,
    required this.expression,
    required this.selected,
    required this.enabled,
    required this.tokenKey,
    required this.onSlotTap,
    required this.onDrop,
    required this.onRemove,
    required this.onDragStart,
    required this.onDragEnd,
  });

  final List<String> digits;
  final ExpressionModel expression;
  final OperatorKind? selected;
  final bool enabled;
  final GlobalKey Function(int gap, int index) tokenKey;
  final void Function(int gap, int index) onSlotTap;
  final void Function(int gap, int index, OperatorDrag drag) onDrop;
  final void Function(int gap, int index) onRemove;
  final ValueChanged<OperatorKind> onDragStart;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 2,
      runSpacing: 10,
      children: [
        for (var g = 0; g < ExpressionModel.gapCount; g++) ...[
          _GapSlot(
            gap: g,
            ops: expression.gaps[g],
            selected: selected,
            enabled: enabled,
            tokenKey: tokenKey,
            onSlotTap: (i) => onSlotTap(g, i),
            onDrop: (i, d) => onDrop(g, i, d),
            onRemove: (i) => onRemove(g, i),
            onDragStart: onDragStart,
            onDragEnd: onDragEnd,
          ),
          if (g < digits.length)
            MathTile(label: digits[g], kind: TileKind.digit, size: 52),
        ],
      ],
    );
  }
}

class _GapSlot extends StatelessWidget {
  const _GapSlot({
    required this.gap,
    required this.ops,
    required this.selected,
    required this.enabled,
    required this.tokenKey,
    required this.onSlotTap,
    required this.onDrop,
    required this.onRemove,
    required this.onDragStart,
    required this.onDragEnd,
  });

  final int gap;
  final List<OperatorKind> ops;
  final OperatorKind? selected;
  final bool enabled;
  final GlobalKey Function(int gap, int index) tokenKey;
  final ValueChanged<int> onSlotTap;
  final void Function(int index, OperatorDrag drag) onDrop;
  final ValueChanged<int> onRemove;
  final ValueChanged<OperatorKind> onDragStart;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final ready = enabled && selected != null;
    final children = <Widget>[];
    for (var i = 0; i <= ops.length; i++) {
      children.add(_InsertSlot(
        compact: ops.isNotEmpty,
        highlight: ready,
        enabled: enabled,
        label: l.gameSlotLabel(gap + 1),
        onTap: ready ? () => onSlotTap(i) : null,
        onDrop: (d) => onDrop(i, d),
      ));
      if (i < ops.length) {
        children.add(_PlacedTile(
          op: ops[i],
          tileKey: tokenKey(gap, i),
          gap: gap,
          index: i,
          enabled: enabled,
          onRemove: () => onRemove(i),
          onDragStart: onDragStart,
          onDragEnd: onDragEnd,
        ));
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}

/// Peça já colocada: tocar remove; arrastar move (ou remove, se soltar fora).
class _PlacedTile extends StatelessWidget {
  const _PlacedTile({
    required this.op,
    required this.tileKey,
    required this.gap,
    required this.index,
    required this.enabled,
    required this.onRemove,
    required this.onDragStart,
    required this.onDragEnd,
  });

  final OperatorKind op;
  final GlobalKey tileKey;
  final int gap;
  final int index;
  final bool enabled;
  final VoidCallback onRemove;
  final ValueChanged<OperatorKind> onDragStart;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    Widget tile = MathTile(
      key: tileKey,
      label: op.symbol,
      size: 44,
      onTap: enabled ? onRemove : null,
    );
    if (enabled) {
      tile = OperatorDraggable(
        data: OperatorDrag(op, fromGap: gap, fromIndex: index),
        feedbackLabel: op.symbol,
        ghostSize: 44,
        onDragStarted: () => onDragStart(op),
        onDragEnd: onDragEnd,
        onCanceled: onRemove, // soltou fora: a peça volta à paleta
        child: tile,
      );
    }
    return OperatorTooltip(op: op, extra: l.gameTileHint, child: tile);
  }
}

class _InsertSlot extends StatelessWidget {
  const _InsertSlot({
    required this.compact,
    required this.highlight,
    required this.enabled,
    required this.label,
    required this.onTap,
    required this.onDrop,
  });

  final bool compact;
  final bool highlight;
  final bool enabled;
  final String label;
  final VoidCallback? onTap;
  final ValueChanged<OperatorDrag> onDrop;

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    return DragTarget<OperatorDrag>(
      onWillAcceptWithDetails: (_) => enabled,
      onAcceptWithDetails: (d) => onDrop(d.data),
      builder: (context, candidate, rejected) {
        final hovering = candidate.isNotEmpty;
        return PixelPressable(
          semanticLabel: label,
          onTap: onTap,
          builder: (context, s) {
            final active = highlight || hovering || s.hover || s.focus;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                // Entre peças o espaço fica fino; ao selecionar/arrastar um
                // operador, todos os pontos de inserção se abrem.
                width: (compact && !active) ? 14 : 36,
                height: 44,
                child: CustomPaint(
                  painter: PixelBoxPainter(
                    fill: hovering
                        ? px.reward.withValues(alpha: 0.75)
                        : (active
                            ? px.reward.withValues(alpha: 0.35)
                            : px.panelFill.withValues(alpha: 0.2)),
                    border: active
                        ? px.reward
                        : px.panelBorder.withValues(alpha: 0.35),
                    pixel: 2,
                    notch: 3,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}