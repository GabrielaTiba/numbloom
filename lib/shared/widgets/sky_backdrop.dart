import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/sprites.dart';
import 'pixel_sprite.dart';

class _CloudSpec {
  const _CloudSpec(this.big, this.y, this.px, this.mul, this.base);
  final bool big; // true = cloudA, false = cloudB
  final double y; // fração da altura
  final double px; // tamanho do "pixel" da nuvem
  final int mul; // voltas por ciclo (inteiro => loop contínuo)
  final double base; // posição inicial (0..1)
}

class _StarSpec {
  const _StarSpec(this.dx, this.dy, this.size, this.phase);
  final double dx;
  final double dy;
  final double size;
  final double phase;
}

/// Céu em pixel art: gradiente em faixas, nuvens à deriva e estrelas
/// cintilantes. Claro = dia; escuro = noite (mais estrelas, nuvens azuladas).
/// Respeita "reduzir movimento" do sistema (animações pausadas).
class SkyBackdrop extends StatefulWidget {
  const SkyBackdrop({super.key, this.child});

  final Widget? child;

  @override
  State<SkyBackdrop> createState() => _SkyBackdropState();
}

class _SkyBackdropState extends State<SkyBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 120));
  bool? _reduce;

  static const _clouds = [
    _CloudSpec(true, 0.08, 9, 1, 0.15),
    _CloudSpec(false, 0.26, 7, 2, 0.60),
    _CloudSpec(true, 0.50, 6, 1, 0.85),
    _CloudSpec(false, 0.68, 8, 2, 0.35),
  ];

  static const _stars = [
    _StarSpec(0.08, 0.10, 15, 0.00),
    _StarSpec(0.93, 0.08, 20, 0.20),
    _StarSpec(0.22, 0.05, 10, 0.50),
    _StarSpec(0.75, 0.14, 10, 0.70),
    _StarSpec(0.50, 0.04, 10, 0.30),
    _StarSpec(0.35, 0.20, 10, 0.90),
    _StarSpec(0.62, 0.22, 10, 0.10),
    _StarSpec(0.04, 0.30, 15, 0.60),
    _StarSpec(0.96, 0.35, 10, 0.40),
    _StarSpec(0.15, 0.45, 10, 0.80),
    _StarSpec(0.85, 0.50, 10, 0.25),
    _StarSpec(0.45, 0.38, 10, 0.55),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (reduce != _reduce) {
      _reduce = reduce;
      if (reduce) {
        _c.stop();
      } else {
        _c.repeat();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final night = Theme.of(context).brightness == Brightness.dark;
    final top = night ? const Color(0xFF0B1B4D) : const Color(0xFF1E5CB3);
    final bottom = night ? const Color(0xFF2E4F94) : const Color(0xFF86DCF5);
    final cloudColors = night
        ? const {'W': Color(0xFF5A74B0), 'b': Color(0xFF3F5590)}
        : const <String, Color>{};
    final starCount = night ? _stars.length : 4;

    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final h = c.maxHeight;
      return Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
            child: CustomPaint(painter: _SkyPainter(top, bottom)),
          ),
          for (var i = 0; i < starCount; i++)
            AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final s = _stars[i];
                final v = 0.35 +
                    0.65 *
                        (0.5 +
                            0.5 *
                                math.sin(2 * math.pi * (_c.value * 40 + s.phase)));
                return Positioned(
                  left: s.dx * w - s.size / 2,
                  top: s.dy * h,
                  child: Opacity(
                    opacity: v,
                    child: PixelSpriteWidget(
                        sprite: Sprites.sparkle, size: s.size),
                  ),
                );
              },
            ),
          for (final spec in _clouds)
            Builder(builder: (context) {
              final base = spec.big ? Sprites.cloudA : Sprites.cloudB;
              final sprite =
                  cloudColors.isEmpty ? base : base.recolor(cloudColors);
              final cw = sprite.width * spec.px;
              return AnimatedBuilder(
                animation: _c,
                child: RepaintBoundary(
                  child: PixelSpriteWidget(sprite: sprite, pixelSize: spec.px),
                ),
                builder: (context, child) {
                  final p = (_c.value * spec.mul + spec.base) % 1.0;
                  return Positioned(
                    left: p * (w + cw) - cw,
                    top: spec.y * h,
                    child: child!,
                  );
                },
              );
            }),
          if (widget.child != null) widget.child!,
        ],
      );
    });
  }
}

class _SkyPainter extends CustomPainter {
  const _SkyPainter(this.top, this.bottom);

  final Color top;
  final Color bottom;
  static const int bands = 14;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = false;
    final bh = size.height / bands;
    for (var i = 0; i < bands; i++) {
      paint.color = Color.lerp(top, bottom, i / (bands - 1))!;
      canvas.drawRect(Rect.fromLTWH(0, i * bh, size.width, bh + 1), paint);
    }
  }

  @override
  bool shouldRepaint(_SkyPainter o) => o.top != top || o.bottom != bottom;
}