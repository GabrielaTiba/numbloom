import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/pixel_theme.dart';
import '../../../core/theme/sprites.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/game_provider.dart';
import '../../../shared/widgets/bloom_loader.dart';
import '../../../shared/widgets/pixel_button.dart';
import '../../../shared/widgets/pixel_dialog.dart';
import '../../../shared/widgets/pixel_sprite.dart';

/// Reação ao ACERTO: uma janela no centro da tela, com uma flor que desabrocha,
/// os pontos ganhos e a fórmula. Só fecha quando o jogador escolhe o que fazer,
/// então ninguém "perde" o momento do acerto.
class SuccessDialog extends ConsumerWidget {
  const SuccessDialog({
    super.key,
    required this.onNext,
    required this.onSeeGarden,
    required this.onRetrySave,
  });

  final VoidCallback onNext;
  final VoidCallback onSeeGarden;
  final VoidCallback onRetrySave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final px = context.pixel;
    final theme = Theme.of(context);
    final fb = ref.watch(gameProvider.select((g) => g.feedback));
    if (fb == null || !fb.correct) return const SizedBox.shrink();

    final List<Widget> actions;
    if (fb.saving) {
      actions = const [];
    } else if (fb.saveFailed) {
      actions = [
        PixelButton(
          label: l.close,
          variant: PixelButtonVariant.neutral,
          onPressed: () => Navigator.of(context).pop(),
        ),
        PixelButton(label: l.retry, onPressed: onRetrySave),
      ];
    } else {
      actions = [
        PixelButton(
          label: l.gameSeeGarden,
          variant: PixelButtonVariant.secondary,
          onPressed: () {
            Navigator.of(context).pop();
            onSeeGarden();
          },
        ),
        PixelButton(
          label: l.gameNext,
          onPressed: () {
            Navigator.of(context).pop();
            onNext();
          },
        ),
      ];
    }

    return PixelDialog(
      title: l.gameCorrectTitle,
      maxWidth: 480,
      actionsAlignment: WrapAlignment.center,
      actions: actions,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _Bloom(),
          const SizedBox(height: 8),
          Text(
            l.resultCorrect,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(color: px.ink),
          ),
          const SizedBox(height: 4),
          Text(
            l.gameCorrectPoints(fb.points),
            style: theme.textTheme.headlineSmall?.copyWith(color: px.action),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Math.tex(
              fb.latex,
              textStyle: TextStyle(fontSize: 22, color: px.ink),
              onErrorFallback: (_) => Text(fb.expressionText),
            ),
          ),
          if (fb.saving) ...[
            const SizedBox(height: 12),
            BloomLoader(size: 32, label: l.gameSaving),
          ],
          if (fb.saveFailed) ...[
            const SizedBox(height: 12),
            Text(l.gameSaveError,
                textAlign: TextAlign.center, style: TextStyle(color: px.action)),
          ],
        ],
      ),
    );
  }
}

/// Flor que desabrocha com brilhos em volta.
class _Bloom extends StatelessWidget {
  const _Bloom();

  static const _spots = [
    Offset(10, 14),
    Offset(130, 8),
    Offset(0, 66),
    Offset(140, 62),
    Offset(34, 0),
    Offset(106, 0),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 130,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          for (var i = 0; i < _spots.length; i++)
            Positioned(
              left: _spots[i].dx,
              top: _spots[i].dy,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 500 + i * 180),
                curve: Curves.easeOutBack,
                builder: (context, v, child) => Opacity(
                  opacity: math.min(1.0, math.max(0.0, v)),
                  child: Transform.scale(scale: v, child: child),
                ),
                child: const PixelSpriteWidget(
                    sprite: Sprites.sparkle,
                    size: 20,
                    alignment: Alignment.center),
              ),
            ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            builder: (context, v, child) => Transform.scale(
              scale: v,
              alignment: Alignment.bottomCenter,
              child: child,
            ),
            child: const PixelSpriteWidget(
              sprite: Sprites.sunflower,
              size: 110,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ],
      ),
    );
  }
}