import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Retângulo "pixelado" (cantos em degrau) com borda, anel opcional,
/// realce e sombra deslocada. Base de painéis, botões e peças.
class PixelBoxPainter extends CustomPainter {
  const PixelBoxPainter({
    required this.fill,
    required this.border,
    this.ring,
    this.pixel = 3,
    this.notch = 3,
    this.shadowColor,
    this.shadowOffset = 0,
    this.highlight,
  });

  final Color fill;
  final Color border;
  final Color? ring;
  final double pixel;
  final double notch;
  final Color? shadowColor;
  final double shadowOffset;
  final Color? highlight;

  static Path shape(Rect r, double n) => Path()
    ..moveTo(r.left + n, r.top)
    ..lineTo(r.right - n, r.top)
    ..lineTo(r.right - n, r.top + n)
    ..lineTo(r.right, r.top + n)
    ..lineTo(r.right, r.bottom - n)
    ..lineTo(r.right - n, r.bottom - n)
    ..lineTo(r.right - n, r.bottom)
    ..lineTo(r.left + n, r.bottom)
    ..lineTo(r.left + n, r.bottom - n)
    ..lineTo(r.left, r.bottom - n)
    ..lineTo(r.left, r.top + n)
    ..lineTo(r.left + n, r.top + n)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final n = math.min(notch, math.min(size.width, size.height) / 4);
    final rect = Offset.zero & size;
    Paint p(Color c) => Paint()
      ..color = c
      ..isAntiAlias = false;

    if (shadowColor != null && shadowOffset > 0) {
      canvas.drawPath(
          shape(rect.shift(Offset(0, shadowOffset)), n), p(shadowColor!));
    }
    canvas.drawPath(shape(rect, n), p(border));
    var inner = rect.deflate(pixel);
    if (ring != null) {
      canvas.drawPath(shape(inner, n), p(ring!));
      inner = inner.deflate(pixel);
    }
    canvas.drawPath(shape(inner, n), p(fill));
    if (highlight != null) {
      canvas.drawRect(
        Rect.fromLTWH(inner.left + n, inner.top, math.max(0, inner.width - 2 * n),
            math.max(1, pixel * 0.66)),
        p(highlight!),
      );
    }
  }

  @override
  bool shouldRepaint(PixelBoxPainter o) =>
      o.fill != fill ||
      o.border != border ||
      o.ring != ring ||
      o.pixel != pixel ||
      o.notch != notch ||
      o.shadowColor != shadowColor ||
      o.shadowOffset != shadowOffset ||
      o.highlight != highlight;
}