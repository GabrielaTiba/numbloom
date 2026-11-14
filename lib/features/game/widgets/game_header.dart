import 'package:flutter/material.dart';

import '../../../core/game/game_level.dart';
import '../../../core/game/game_level_l10n.dart';
import '../../../core/theme/pixel_theme.dart';
import '../../../core/theme/sprites.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/pixel_sprite.dart';
import '../../../shared/widgets/wood_panel.dart';

/// Nível (fichas) e pontuação.
class GameHeader extends StatelessWidget {
  const GameHeader({
    super.key,
    required this.level,
    required this.score,
    required this.enabled,
    required this.onLevelChanged,
  });

  final GameLevel level;
  final int score;
  final bool enabled;
  final ValueChanged<GameLevel> onLevelChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final px = context.pixel;
    final theme = Theme.of(context);
    return WoodPanel(
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 12,
        spacing: 16,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.gameLevelLabel,
                  style: theme.textTheme.titleMedium?.copyWith(color: px.action)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  for (final v in GameLevel.values)
                    ChoiceChip(
                      label: Text(v.label(l)),
                      selected: v == level,
                      onSelected: enabled ? (_) => onLevelChanged(v) : null,
                    ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PixelSpriteWidget(
                  sprite: Sprites.flowerYellow,
                  size: 44,
                  alignment: Alignment.center),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l.gameScore, style: theme.textTheme.bodySmall),
                  Text('$score',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(color: px.ink)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}