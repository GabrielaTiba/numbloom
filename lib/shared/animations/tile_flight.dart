import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/math_tile.dart';

/// Uma peça que "voa" de [from] até [to] (posições globais, canto superior
/// esquerdo).
class TileFlightSpec {
  const TileFlightSpec({
    required this.from,
    required this.to,
    required this.label,
    this.fromSize = 44,
    this.toSize = 52,
  });

  final Offset from;
  final Offset to;
  final String label;
  final double fromSize;
  final double toSize;
}

/// Posição global do canto superior esquerdo do widget da [key].
Offset? globalTopLeft(GlobalKey key) {
  final box = key.currentContext?.findRenderObject();
  if (box is RenderBox && box.attached) return box.localToGlobal(Offset.zero);
  return null;
}

/// ANIMAÇÃO OBRIGATÓRIA: após "Verificar", as peças saem da expressão e
/// voltam aos seus botões da paleta (com um pulinho e escalonadas).
/// Completa quando a última peça chega. Respeita "reduzir movimento".
Future<void> playTileFlight(
  BuildContext context,
  List<TileFlightSpec> specs, {
  Duration duration = const Duration(milliseconds: 800),
}) async {
  if (specs.isEmpty || MediaQuery.disableAnimationsOf(context)) return;

  final overlay = Overlay.of(context, rootOverlay: true);
  final overlayBox = overlay.context.findRenderObject() as RenderBox;
  final local = [
    for (final s in specs)
      (
        from: overlayBox.globalToLocal(s.from),
        to: overlayBox.globalToLocal(s.to),
        spec: s,
      ),
  ];

  // OverlayState é um TickerProvider.
  final controller = AnimationController(vsync: overlay, duration: duration);
  final entry = OverlayEntry(
    builder: (context) => IgnorePointer(
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox.expand(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final n = local.length;
              final stagger = math.min(0.05, 0.3 / n);
              return Stack(
                children: [
                  for (var i = 0; i < n; i++)
                    _flying(local[i].from, local[i].to, local[i].spec, i,
                        stagger, controller.value),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  try {
    await controller.forward();
  } finally {
    entry.remove();
    controller.dispose();
  }
}

Widget _flying(Offset from, Offset to, TileFlightSpec spec, int i,
    double stagger, double value) {
  final start = i * stagger;
  final end = math.min(1.0, start + 0.7);
  final t = Interval(start, end, curve: Curves.easeInOutCubic).transform(value);
  final pos = Offset.lerp(from, to, t)!;
  final hop = -math.sin(math.pi * t) * 48; // arco do "pulinho"
  final size = spec.fromSize + (spec.toSize - spec.fromSize) * t;
  return Positioned(
    left: pos.dx,
    top: pos.dy + hop,
    child: MathTile(label: spec.label, size: size),
  );
}