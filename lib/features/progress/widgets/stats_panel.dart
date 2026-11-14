import 'package:flutter/material.dart';

import '../../../core/game/game_level.dart';
import '../../../core/game/game_level_l10n.dart';
import '../../../core/theme/pixel_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/progress_model.dart';
import '../../../shared/widgets/pixel_progress_bar.dart';
import '../../../shared/widgets/wood_panel.dart';

/// Pontuação, resolvidos, conclusão e progresso por nível.
class StatsPanel extends StatelessWidget {
  const StatsPanel({super.key, required this.progress});

  final ProgressModel progress;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final px = context.pixel;
    final theme = Theme.of(context);

    Widget stat(String label, String value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodySmall),
            Text(value,
                style:
                    theme.textTheme.headlineSmall?.copyWith(color: px.action)),
          ],
        );

    final percent = (progress.completion * 100).toStringAsFixed(1);

    return WoodPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 32,
            runSpacing: 12,
            children: [
              stat(l.gameScore, '${progress.score}'),
              stat(l.progressSolved, '${progress.solvedCount}'),
              stat(l.progressCompletion, '$percent%'),
            ],
          ),
          const SizedBox(height: 16),
          Text(l.progressByLevel,
              style: theme.textTheme.titleMedium?.copyWith(color: px.ink)),
          const SizedBox(height: 8),
          for (final level in GameLevel.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(level.label(l),
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(l.progressLevelCount(progress.countAt(level),
                          ProgressModel.totalPerLevel)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  PixelProgressBar(
                    value: progress.countAt(level) / ProgressModel.totalPerLevel,
                    semanticLabel: level.label(l),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}