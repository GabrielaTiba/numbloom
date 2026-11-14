import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme.dart';

/// Gramado quadriculado com tufos, determinístico (sem aleatoriedade).
class GrassPainter extends CustomPainter {
  const GrassPainter({required this.tile, required this.a, required this.b});

  final double tile;
  final Color a;
  final Color b;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = false;
    final tuft = Paint()
      ..isAntiAlias = false
      ..color = Color.alphaBlend(const Color(0x22000000), b);
    final cols = (size.width / tile).ceil();
    final rows = (size.height / tile).ceil();
    final t = tile / 6;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        paint.color = (r + c).isEven ? a : b;
        canvas.drawRect(
            Rect.fromLTWH(c * tile, r * tile, tile + 0.5, tile + 0.5), paint);
        if ((r * 31 + c * 17 + r * c * 7) % 11 == 0) {
          final x = c * tile + tile * 0.3;
          final y = r * tile + tile * 0.4;
          canvas.drawRect(Rect.fromLTWH(x, y, t, t * 2), tuft);
          canvas.drawRect(Rect.fromLTWH(x + t * 2, y + t, t, t), tuft);
        }
      }
    }
  }

  @override
  bool shouldRepaint(GrassPainter o) =>
      o.tile != tile || o.a != a || o.b != b;
}

/// Fundo de gramado para as páginas (contraste suave para não competir
/// com o conteúdo).
class GrassBackdrop extends StatelessWidget {
  const GrassBackdrop({super.key, this.child, this.tile = 28});

  final Widget? child;
  final double tile;

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: CustomPaint(
            painter: GrassPainter(tile: tile, a: px.grassA, b: px.grassB),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}