import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme.dart';
import 'pixel_box.dart';
import 'pixel_pressable.dart';

/// Botão-caixote de madeira: rótulo no topo e um ícone em pixel art embaixo
/// (inspirado na atmosfera do menu de jogos de fazenda, com arte original).
class CrateButton extends StatelessWidget {
  const CrateButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.width = 168,
    this.height = 140,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    final theme = Theme.of(context);
    return PixelPressable(
      semanticLabel: label,
      onTap: onPressed,
      builder: (context, s) {
        final down = s.pressed ? 3.0 : 0.0;
        final lift = s.hover && !s.pressed ? -2.0 : 0.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            transform: Matrix4.translationValues(0, down + lift, 0),
            width: width,
            height: height,
            child: CustomPaint(
              painter: PixelBoxPainter(
                fill: px.panelFill,
                ring: s.focus ? px.reward : px.panelRing,
                border: px.panelBorder,
                pixel: 4,
                notch: 4,
                shadowColor: px.shadow,
                shadowOffset: 5 - down,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(color: px.action),
                      ),
                    ),
                    Expanded(child: Center(child: icon)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}