import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/pixel_theme.dart';
import '../../../core/theme/sprites.dart';
import '../../../shared/widgets/grass_backdrop.dart';
import '../../../shared/widgets/pixel_sprite.dart';

/// O jardim do jogador. Cada desafio resolvido planta uma nova muda numa
/// posição fixa (ordem determinística); as plantas mais antigas crescem:
/// broto -> jovem -> adulta (flor, cogumelo ou árvore, conforme a parcela).
/// Com mais de [plotCount] desafios, as plantas existentes seguem crescendo.
class GardenView extends StatelessWidget {
  const GardenView({
    super.key,
    required this.solvedCount,
    this.plotCount = 24,
    this.semanticLabel,
  });

  final int solvedCount;
  final int plotCount;
  final String? semanticLabel;

  /// order[k] = posição (0..plotCount-1) onde nasce a k-ésima planta.
  static List<int> plantingOrder(int count) {
    final idx = List<int>.generate(count, (i) => i);
    int key(int i) => (i * 2654435761 + 97) % 4294967296;
    idx.sort((a, b) => key(a).compareTo(key(b)));
    return idx;
  }

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    return LayoutBuilder(builder: (context, c) {
      final width = c.maxWidth.isFinite ? c.maxWidth : 360.0;
      final cols = (width / 84).floor().clamp(4, 8);
      final rows = (plotCount / cols).ceil();
      final cell = width / cols;
      final order = plantingOrder(plotCount);
      final plantAt = List<int>.filled(plotCount, 0);
      for (var k = 0; k < plotCount; k++) {
        plantAt[order[k]] = k;
      }
      return Semantics(
        label: semanticLabel,
        image: true,
        child: ClipRect(
          child: SizedBox(
            width: width,
            height: rows * cell,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: GrassPainter(
                        tile: cell / 2, a: px.grassA, b: px.grassB),
                  ),
                ),
                for (var p = 0; p < plotCount; p++)
                  Positioned(
                    left: (p % cols) * cell,
                    top: (p ~/ cols) * cell,
                    width: cell,
                    height: cell,
                    child: _Plot(
                      cell: cell,
                      plotIndex: plantAt[p],
                      age: solvedCount - plantAt[p],
                    ),
                  ),
                // Borboletas: uma a cada 5 desafios resolvidos (até 3).
                if (solvedCount >= 5)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: _Butterflies(count: math.min(3, solvedCount ~/ 5)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _Plot extends StatelessWidget {
  const _Plot({required this.cell, required this.plotIndex, required this.age});

  final double cell;
  final int plotIndex;
  final int age;

  @override
  Widget build(BuildContext context) {
    final visual = age > 0 ? PlantSprites.forPlot(plotIndex, age) : null;
    final sprite = visual?.sprite ?? Sprites.soil;
    final scale = visual?.scale ?? 0.6;
    final stage = visual?.stage ?? 0;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      switchInCurve: Curves.elasticOut,
      transitionBuilder: (child, anim) => ScaleTransition(
        scale: anim,
        alignment: Alignment.bottomCenter,
        child: child,
      ),
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.bottomCenter,
        children: [...previous, if (current != null) current],
      ),
      child: KeyedSubtree(
        key: ValueKey(stage),
        child: PixelSpriteWidget(sprite: sprite, size: cell * 0.9 * scale),
      ),
    );
  }
}

/// Borboletas que voam pelo jardim (animação suave; paradas se o sistema
/// pedir "reduzir movimento").
class _Butterflies extends StatefulWidget {
  const _Butterflies({required this.count});

  final int count;

  @override
  State<_Butterflies> createState() => _ButterfliesState();
}

class _ButterfliesState extends State<_Butterflies>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 30));
  bool? _reduce;

  static final List<PixelSprite> _wings = [
    Sprites.butterfly.recolor({'W': const Color(0xFFF2994A)}),
    Sprites.butterfly.recolor({'W': const Color(0xFF7FB7E8)}),
    Sprites.butterfly.recolor({'W': const Color(0xFFF08CA8)}),
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
    return LayoutBuilder(builder: (context, box) {
      const w = 27.0; // 9 colunas x 3 px
      const h = 18.0; // 6 linhas x 3 px
      return AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value;
          return Stack(
            children: [
              for (var i = 0; i < widget.count; i++)
                Positioned(
                  left: (box.maxWidth - w) *
                      (0.5 + 0.45 * math.sin(2 * math.pi * (t * 2 + i * 0.31))),
                  top: (box.maxHeight - h) *
                      (0.5 +
                          0.42 *
                              math.sin(2 * math.pi * (t * 3 + i * 0.57) + 1.0)),
                  child: Transform(
                    alignment: Alignment.center,
                    // Bater de asas: a largura oscila.
                    transform: Matrix4.diagonal3Values(
                      0.35 +
                          0.65 *
                              (0.5 +
                                  0.5 *
                                      math.sin(2 * math.pi * (t * 120 + i * 0.4))),
                      1,
                      1,
                    ),
                    child: PixelSpriteWidget(
                      sprite: _wings[i % _wings.length],
                      pixelSize: 3,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
            ],
          );
        },
      );
    });
  }
}