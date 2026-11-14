import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme.dart';
import '../../core/theme/sprites.dart';
import '../../l10n/generated/app_localizations.dart';
import 'pixel_sprite.dart';

/// Logotipo NumBloom (broto + nome em fonte pixelada + slogan).
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final px = context.pixel;
    final title = compact
        ? theme.textTheme.titleLarge
        : theme.textTheme.headlineMedium;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PixelSpriteWidget(
            sprite: Sprites.flowerRed, size: compact ? 36 : 60),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.appName, style: title?.copyWith(color: px.ink)),
              if (!compact)
                Text(
                  l.slogan,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: px.ink, fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
      ],
    );
  }
}