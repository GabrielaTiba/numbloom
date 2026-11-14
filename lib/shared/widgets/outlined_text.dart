import 'package:flutter/material.dart';

/// Texto com contorno "pixelado" (8 sombras sem blur) e sombra projetada.
class OutlinedText extends StatelessWidget {
  const OutlinedText(
    this.text, {
    super.key,
    required this.style,
    required this.outline,
    this.thickness = 3,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final Color outline;
  final double thickness;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final o = thickness;
    final shadows = <Shadow>[
      for (final dx in [-o, 0.0, o])
        for (final dy in [-o, 0.0, o])
          if (dx != 0 || dy != 0) Shadow(color: outline, offset: Offset(dx, dy)),
      Shadow(color: outline, offset: Offset(0, o * 2)),
    ];
    return Text(
      text,
      textAlign: textAlign,
      style: (style ?? const TextStyle()).copyWith(shadows: shadows),
    );
  }
}