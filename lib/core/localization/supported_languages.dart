import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../shared/widgets/pixel_sprite.dart';
import '../theme/sprites.dart';

/// Idioma oferecido no seletor da página de login (com bandeira em pixel art).
class SupportedLanguage {
  const SupportedLanguage(this.locale, this.flag, this._label);

  final Locale locale;
  final PixelSprite flag;
  final String Function(AppLocalizations) _label;

  String label(AppLocalizations l) => _label(l);
}

class SupportedLanguages {
  const SupportedLanguages._();

  static final List<SupportedLanguage> all = [
    SupportedLanguage(
        const Locale('pt'), Sprites.flagBr, (l) => l.languagePortuguese),
    SupportedLanguage(
        const Locale('en'), Sprites.flagUs, (l) => l.languageEnglish),
  ];
}