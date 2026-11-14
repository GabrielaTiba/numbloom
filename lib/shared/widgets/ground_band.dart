import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme.dart';
import '../../core/theme/sprites.dart';
import 'grass_backdrop.dart';
import 'pixel_sprite.dart';

/// Faixa de gramado com plantas na base da tela (decorativa).
class GroundBand extends StatelessWidget {
  const GroundBand({super.key});

  static final _plants = [
    Sprites.flowerRed,
    Sprites.mushroom,
    Sprites.tree,
    Sprites.flowerPink,
    Sprites.bush,
    Sprites.flowerYellow,
    Sprites.sprout,
  ];

  @override
  Widget build(BuildContext context) {
    final night = Theme.of(context).brightness == Brightness.dark;
    final px = context.pixel;
    final a = night ? px.grassA : const Color(0xFF86B85F);
    final b = night ? px.grassB : const Color(0xFF7CAE56);
    return LayoutBuilder(builder: (context, c) {
      final n = (c.maxWidth / 96).floor().clamp(3, 14);
      return SizedBox(
        height: 128,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 72,
              child: CustomPaint(painter: GrassPainter(tile: 18, a: a, b: b)),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 62,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < n; i++)
                    PixelSpriteWidget(
                      sprite: _plants[i % _plants.length],
                      size: (i % _plants.length) == 2 ? 64 : 48,
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}