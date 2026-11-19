import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../core/game/expression_error_l10n.dart';
import '../../../core/game/expression_evaluator.dart';
import '../../../core/theme/pixel_theme.dart';
import '../../../core/theme/sprites.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/game_provider.dart';
import '../../../shared/widgets/bloom_loader.dart';
import '../../../shared/widgets/pixel_button.dart';
import '../../../shared/widgets/pixel_sprite.dart';
import '../../../shared/widgets/wood_panel.dart';

/// Resultado da verificação: acerto (com pontos e salvamento), erro de
/// sintaxe/domínio ou valores diferentes.
class FeedbackPanel extends StatelessWidget {
  const FeedbackPanel({
    super.key,
    required this.feedback,
    required this.onNext,
    required this.onRetrySave,
  });

  final GameFeedback feedback;
  final VoidCallback onNext;
  final VoidCallback onRetrySave;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final px = context.pixel;
    final theme = Theme.of(context);
    final ok = feedback.correct;

    final message = ok
        ? l.resultCorrect
        : (feedback.errorCode != null
            ? feedback.errorCode!.localized(l, feedback.errorToken)
            : l.resultWrong(formatNumber(feedback.left ?? 0),
                formatNumber(feedback.right ?? 0)));

    return WoodPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: PixelSpriteWidget(
                  sprite: ok ? Sprites.flowerRed : Sprites.sprout,
                  size: 56,
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: ok ? px.ink : px.action),
                    ),
                    if (ok) Text(l.gameCorrectPoints(feedback.points)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Math.tex(
                feedback.latex,
                textStyle: TextStyle(fontSize: 22, color: px.ink),
                onErrorFallback: (_) => Text(feedback.expressionText),
              ),
            ),
          ),
          if (!ok) ...[
            const SizedBox(height: 8),
            Text(
              l.gameWrongKeep,
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
          if (ok) ...[
            const SizedBox(height: 12),
            if (feedback.saving)
              BloomLoader(size: 32, label: l.gameSaving)
            else if (feedback.saveFailed) ...[
              Text(l.gameSaveError,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: px.action)),
              const SizedBox(height: 8),
              PixelButton(
                label: l.retry,
                variant: PixelButtonVariant.neutral,
                onPressed: onRetrySave,
              ),
            ] else
              PixelButton(
                label: l.gameNext,
                expanded: true,
                onPressed: onNext,
              ),
          ],
        ],
      ),
    );
  }
}