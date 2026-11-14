import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme.dart';
import 'pixel_box.dart';
import 'pixel_pressable.dart';

/// Caixote pequeno e quadrado para ícones (tema, som, voltar...).
/// Área de toque >= 44 px.
class MiniCrateButton extends StatelessWidget {
  const MiniCrateButton({
    super.key,
    required this.child,
    required this.semanticLabel,
    required this.onTap,
    this.selected = false,
    this.size = 54,
  });

  final Widget child;
  final String semanticLabel;
  final VoidCallback onTap;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    return PixelPressable(
      semanticLabel: semanticLabel,
      selected: selected,
      onTap: onTap,
      builder: (context, s) {
        final dy = selected ? -3.0 : (s.pressed ? 2.0 : (s.hover ? -1.0 : 0.0));
        return Tooltip(
          message: semanticLabel,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              transform: Matrix4.translationValues(0, dy, 0),
              width: size,
              height: size,
              child: CustomPaint(
                painter: PixelBoxPainter(
                  fill: px.panelFill,
                  ring: (selected || s.focus) ? px.reward : px.panelRing,
                  border: px.panelBorder,
                  pixel: 3,
                  notch: 3,
                  shadowColor: px.shadow,
                  shadowOffset: selected ? 5 : 3,
                ),
                child: Center(child: child),
              ),
            ),
          ),
        );
      },
    );
  }
}