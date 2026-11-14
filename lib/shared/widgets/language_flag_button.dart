import 'package:flutter/material.dart';

import '../../core/localization/supported_languages.dart';
import '../../core/theme/pixel_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import 'pixel_box.dart';
import 'pixel_pressable.dart';
import 'pixel_sprite.dart';

/// Caixote pequeno com a bandeira do idioma. O selecionado sobe e ganha
/// borda de recompensa (amarelo-manteiga).
class LanguageFlagButton extends StatelessWidget {
  const LanguageFlagButton({
    super.key,
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final SupportedLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    final l = AppLocalizations.of(context)!;
    return PixelPressable(
      semanticLabel: language.label(l),
      selected: selected,
      onTap: onTap,
      builder: (context, s) {
        final dy = selected ? -3.0 : (s.pressed ? 2.0 : (s.hover ? -1.0 : 0.0));
        return Tooltip(
          message: language.label(l),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              transform: Matrix4.translationValues(0, dy, 0),
              width: 68,
              height: 54,
              child: CustomPaint(
                painter: PixelBoxPainter(
                  fill: px.panelFill,
                  ring: (selected || s.focus) ? px.reward : px.panelRing,
                  border: px.panelBorder,
                  pixel: 3,
                  notch: 3,
                  shadowColor: px.shadow,
                  shadowOffset: selected ? 5 : 3,
                ),
                child: Center(
                  child: PixelSpriteWidget(
                    sprite: language.flag,
                    pixelSize: 2,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}