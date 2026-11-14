import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Sprite em pixel art definido por texto: cada caractere é um pixel;
/// '.' é transparente. As cores vêm da [palette].
class PixelSprite {
  const PixelSprite(this.rows, this.palette);

  final List<String> rows;
  final Map<String, Color> palette;

  int get height => rows.length;
  int get width {
    var w = 0;
    for (final r in rows) {
      if (r.length > w) w = r.length;
    }
    return w;
  }

  PixelSprite recolor(Map<String, Color> overrides) =>
      PixelSprite(rows, {...palette, ...overrides});
}

class PixelSpriteWidget extends StatelessWidget {
  const PixelSpriteWidget({
    super.key,
    required this.sprite,
    this.size = 48,
    this.pixelSize,
    this.alignment = Alignment.bottomCenter,
    this.semanticLabel,
  });

  final PixelSprite sprite;

  /// Lado do quadrado onde o sprite é desenhado (usado se [pixelSize] for nulo).
  final double size;

  /// Se informado, cada "pixel" do sprite mede [pixelSize] e o widget ganha
  /// a proporção real do sprite (útil para nuvens e bandeiras, que não são
  /// quadradas).
  final double? pixelSize;
  final Alignment alignment;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final w = pixelSize != null ? sprite.width * pixelSize! : size;
    final h = pixelSize != null ? sprite.height * pixelSize! : size;
    final painted = SizedBox(
      width: w,
      height: h,
      child: CustomPaint(painter: _SpritePainter(sprite, alignment)),
    );
    if (semanticLabel == null) {
      return ExcludeSemantics(child: painted);
    }
    return Semantics(label: semanticLabel, image: true, child: painted);
  }
}

class _SpritePainter extends CustomPainter {
  _SpritePainter(this.sprite, this.alignment);

  final PixelSprite sprite;
  final Alignment alignment;

  @override
  void paint(Canvas canvas, Size size) {
    if (sprite.width == 0 || sprite.height == 0) return;
    final px = math.min(size.width / sprite.width, size.height / sprite.height);
    final ox = (size.width - sprite.width * px) * (alignment.x + 1) / 2;
    final oy = (size.height - sprite.height * px) * (alignment.y + 1) / 2;
    final paint = Paint()..isAntiAlias = false;
    for (var y = 0; y < sprite.rows.length; y++) {
      final row = sprite.rows[y];
      for (var x = 0; x < row.length; x++) {
        final color = sprite.palette[row[x]];
        if (color == null) continue;
        paint.color = color;
        // +0.4 evita frestas entre pixels em tamanhos fracionários.
        canvas.drawRect(
            Rect.fromLTWH(ox + x * px, oy + y * px, px + 0.4, px + 0.4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SpritePainter old) =>
      old.sprite != sprite || old.alignment != alignment;
}