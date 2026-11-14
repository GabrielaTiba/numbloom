import 'package:flutter/material.dart';

import '../../../core/game/operator_kind.dart';
import '../../../shared/widgets/math_tile.dart';

/// O que está sendo arrastado: um operador da paleta (sem origem) ou uma
/// peça que já está na expressão ([fromGap]/[fromIndex]).
class OperatorDrag {
  const OperatorDrag(this.op, {this.fromGap, this.fromIndex});

  final OperatorKind op;
  final int? fromGap;
  final int? fromIndex;

  bool get fromBoard => fromGap != null && fromIndex != null;
}

/// Torna uma peça arrastável. Mouse (computador/web): arrasta na hora.
/// Toque (celular/tablet): segura um instante, para não brigar com a rolagem.
class OperatorDraggable extends StatelessWidget {
  const OperatorDraggable({
    super.key,
    required this.data,
    required this.feedbackLabel,
    required this.child,
    this.ghostSize = 52,
    this.onDragStarted,
    this.onDragEnd,
    this.onCanceled,
  });

  final OperatorDrag data;
  final String feedbackLabel;
  final Widget child;
  final double ghostSize;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnd;

  /// Soltou fora de qualquer espaço (ex.: para remover uma peça da expressão).
  final VoidCallback? onCanceled;

  @override
  Widget build(BuildContext context) {
    final feedback = Material(
      type: MaterialType.transparency,
      child: MathTile(label: feedbackLabel, selected: true, size: ghostSize),
    );
    final placeholder =
        MathTile(label: feedbackLabel, ghost: true, size: ghostSize);

    final platform = Theme.of(context).platform;
    final touch = platform == TargetPlatform.android ||
        platform == TargetPlatform.iOS ||
        platform == TargetPlatform.fuchsia;

    if (touch) {
      return LongPressDraggable<OperatorDrag>(
        data: data,
        delay: const Duration(milliseconds: 150),
        feedback: feedback,
        childWhenDragging: placeholder,
        onDragStarted: onDragStarted,
        onDragEnd: (_) => onDragEnd?.call(),
        onDraggableCanceled: (_, __) => onCanceled?.call(),
        child: child,
      );
    }
    return Draggable<OperatorDrag>(
      data: data,
      feedback: feedback,
      childWhenDragging: placeholder,
      onDragStarted: onDragStarted,
      onDragEnd: (_) => onDragEnd?.call(),
      onDraggableCanceled: (_, __) => onCanceled?.call(),
      child: child,
    );
  }
}