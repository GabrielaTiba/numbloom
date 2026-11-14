import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme.dart';
import '../../core/theme/sprites.dart';
import '../../l10n/generated/app_localizations.dart';
import 'mini_crate_button.dart';
import 'pixel_sprite.dart';

/// Dois botões: música de fundo (nota) e efeitos sonoros (alto-falante).
/// Presente em TODAS as telas. Versão "pura" (sem Riverpod).
class SoundControls extends StatelessWidget {
  const SoundControls({
    super.key,
    required this.musicOn,
    required this.onToggleMusic,
    required this.sfxOn,
    required this.onToggleSfx,
    this.buttonSize = 54,
  });

  final bool musicOn;
  final VoidCallback onToggleMusic;
  final bool sfxOn;
  final VoidCallback onToggleSfx;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final px = context.pixel;
    final ps = buttonSize >= 52 ? 3.0 : 2.4;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MiniCrateButton(
          size: buttonSize,
          semanticLabel: musicOn ? l.musicTurnOff : l.musicTurnOn,
          selected: musicOn,
          onTap: onToggleMusic,
          child: PixelSpriteWidget(
            sprite: (musicOn ? Sprites.musicNote : Sprites.musicOff)
                .recolor({'#': px.ink}),
            pixelSize: ps,
            alignment: Alignment.center,
          ),
        ),
        const SizedBox(width: 8),
        MiniCrateButton(
          size: buttonSize,
          semanticLabel: sfxOn ? l.soundTurnOff : l.soundTurnOn,
          selected: sfxOn,
          onTap: onToggleSfx,
          child: PixelSpriteWidget(
            sprite: (sfxOn ? Sprites.speakerOn : Sprites.speakerOff)
                .recolor({'#': px.ink}),
            pixelSize: ps,
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }
}