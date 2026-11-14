import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme.dart';
import 'pixel_box.dart';

/// Barra de progresso "de jogo" (0..1).
class PixelProgressBar extends StatelessWidget {
  const PixelProgressBar({
    super.key,
    required this.value,
    this.color,
    this.height = 18,
    this.semanticLabel,
  });

  final double value;
  final Color? color;
  final double height;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    final fill = color ?? Theme.of(context).colorScheme.primary;
    final v = value.clamp(0.0, 1.0);
    return Semantics(
      label: semanticLabel,
      value: '${(v * 100).round()}%',
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: CustomPaint(
            painter: PixelBoxPainter(
              fill: px.tileFace,
              border: px.panelBorder,
              pixel: 2,
              notch: 2,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: v,
                  heightFactor: 1,
                  child: ColoredBox(color: fill),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}