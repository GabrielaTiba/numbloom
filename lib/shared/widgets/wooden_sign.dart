import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme.dart';
import '../../core/theme/sprites.dart';
import 'outlined_text.dart';
import 'pixel_box.dart';
import 'pixel_sprite.dart';

/// Placa de madeira com o logotipo (nome em fonte pixelada com contorno,
/// slogan, folhas e pregos). Arte original do NumBloom.
class WoodenSign extends StatelessWidget {
  const WoodenSign({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    final theme = Theme.of(context);
    const pixel = 6.0;

    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final compact = w < 460;
      final fs = ((w - (compact ? 64 : 150)) / 5.0).clamp(28.0, 64.0);

      final content = Padding(
        padding: EdgeInsets.fromLTRB(
            pixel * 2 + 20, pixel * 2 + 22, pixel * 2 + 20, pixel * 2 + 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!compact) ...[
                  PixelSpriteWidget(
                      sprite: Sprites.flowerRed, pixelSize: 6.5),
                  const SizedBox(width: 12),
                ],
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: OutlinedText(
                      title,
                      outline: px.panelBorder,
                      thickness: 3,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: fs,
                        color: px.action,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: px.ink,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

      return Padding(
        padding: const EdgeInsets.only(bottom: pixel, top: 14),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
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
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _PlankPainter(
                  line: px.panelRing.withValues(alpha: 0.28),
                  nail: px.panelBorder,
                  nailShine: px.reward,
                  inset: pixel * 2 + 6,
                ),
              ),
            ),
            content,
            const Positioned(
              top: -14,
              left: -8,
              child: PixelSpriteWidget(sprite: Sprites.leaf, pixelSize: 5),
            ),
            Positioned(
              top: -12,
              right: -8,
              child: Transform.flip(
                flipX: true,
                child: const PixelSpriteWidget(
                    sprite: Sprites.leaf, pixelSize: 5),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _PlankPainter extends CustomPainter {
  const _PlankPainter({
    required this.line,
    required this.nail,
    required this.nailShine,
    required this.inset,
  });

  final Color line;
  final Color nail;
  final Color nailShine;
  final double inset;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..isAntiAlias = false;
    // Divisões das tábuas.
    p.color = line;
    for (final f in [0.30, 0.62]) {
      canvas.drawRect(
          Rect.fromLTWH(inset, size.height * f, size.width - inset * 2, 3), p);
    }
    // Pregos nos cantos.
    final pts = [
      Offset(inset + 4, inset + 4),
      Offset(size.width - inset - 12, inset + 4),
      Offset(inset + 4, size.height - inset - 12),
      Offset(size.width - inset - 12, size.height - inset - 12),
    ];
    for (final o in pts) {
      p.color = nail;
      canvas.drawRect(Rect.fromLTWH(o.dx, o.dy, 8, 8), p);
      p.color = nailShine;
      canvas.drawRect(Rect.fromLTWH(o.dx + 1, o.dy + 1, 3, 3), p);
    }
  }

  @override
  bool shouldRepaint(_PlankPainter o) =>
      o.line != line || o.nail != nail || o.inset != inset;
}