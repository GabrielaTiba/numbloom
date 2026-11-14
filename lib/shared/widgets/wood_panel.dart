import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme.dart';
import 'pixel_box.dart';

/// Painel com moldura de madeira e interior de pergaminho (boa leitura).
class WoodPanel extends StatelessWidget {
  const WoodPanel({
    super.key,
    required this.child,
    this.title,
    this.padding = const EdgeInsets.all(16),
    this.pixel = 4,
    this.fillChild = false,
  });

  final Widget child;
  final String? title;
  final EdgeInsetsGeometry padding;
  final double pixel;

  /// true: o filho ocupa o espaço restante (use em diálogos com altura
  /// limitada, para que o conteúdo role em vez de estourar).
  final bool fillChild;

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: pixel),
      child: CustomPaint(
        painter: PixelBoxPainter(
          fill: px.panelFill,
          ring: px.panelRing,
          border: px.panelBorder,
          pixel: pixel,
          notch: pixel,
          shadowColor: px.shadow,
          shadowOffset: pixel,
        ),
        child: Padding(
          padding: EdgeInsets.all(pixel * 2).add(padding),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: px.ink),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: theme.textTheme.titleLarge?.copyWith(color: px.ink),
                  ),
                  const SizedBox(height: 12),
                ],
                if (fillChild) Flexible(child: child) else child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}