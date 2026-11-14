import 'package:flutter/material.dart';

import '../../../core/localization/supported_languages.dart';
import '../../../core/theme/sprites.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/language_flag_button.dart';
import '../../../shared/widgets/mini_crate_button.dart';
import '../../../shared/widgets/pixel_sprite.dart';
import '../../../shared/widgets/sound_controls.dart';

/// Idioma (bandeiras), modo claro/escuro, música e efeitos sonoros.
/// Versão "pura" (sem Riverpod), usada também nas demos.
class TitleControls extends StatelessWidget {
  const TitleControls({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
    required this.isDark,
    required this.onToggleTheme,
    required this.musicOn,
    required this.onToggleMusic,
    required this.sfxOn,
    required this.onToggleSfx,
    this.showLanguage = true,
    this.buttonSize = 54,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final bool musicOn;
  final VoidCallback onToggleMusic;
  final bool sfxOn;
  final VoidCallback onToggleSfx;

  /// Bandeiras (só na entrada; nas telas logadas o idioma fica em Configurações).
  final bool showLanguage;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final ps = buttonSize >= 52 ? 3.0 : 2.4;
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        if (showLanguage)
          for (final lang in SupportedLanguages.all)
            LanguageFlagButton(
              language: lang,
              selected: lang.locale.languageCode == locale.languageCode,
              onTap: () => onLocaleChanged(lang.locale),
            ),
        // Mostra o ícone do modo para o qual o toque vai levar.
        MiniCrateButton(
          size: buttonSize,
          semanticLabel: isDark ? l.themeSwitchToLight : l.themeSwitchToDark,
          onTap: onToggleTheme,
          child: PixelSpriteWidget(
            sprite: isDark ? Sprites.sun : Sprites.moon,
            pixelSize: ps,
            alignment: Alignment.center,
          ),
        ),
        SoundControls(
          buttonSize: buttonSize,
          musicOn: musicOn,
          onToggleMusic: onToggleMusic,
          sfxOn: sfxOn,
          onToggleSfx: onToggleSfx,
        ),
      ],
    );
  }
}