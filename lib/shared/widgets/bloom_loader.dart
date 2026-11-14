import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// Indicador de progresso do NumBloom (pacote loading_animation_widget),
/// no lugar do CircularProgressIndicator padrão.
class BloomLoader extends StatelessWidget {
  const BloomLoader({super.key, this.size = 48, this.label});

  final double size;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Semantics(
      label: label,
      liveRegion: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(color: color, size: size),
          if (label != null) ...[
            const SizedBox(height: 8),
            Text(label!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}