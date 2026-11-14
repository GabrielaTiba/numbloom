import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Preferências do usuário (persistidas em SharedPreferences).
@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system, // padrão do dispositivo
    this.fontScale = 1.0,
    this.fontFamily = 'Roboto',
    this.seedColor = NumBloomColors.moss,
    this.localeCode, // null = idioma do dispositivo
    this.sfxOn = false, // efeitos sonoros (começam desligados)
    this.musicOn = false, // música de fundo (começa desligada)
  });

  final ThemeMode themeMode;
  final double fontScale;
  final String fontFamily;
  final Color seedColor;
  final String? localeCode;
  final bool sfxOn;
  final bool musicOn;

  AppSettings copyWith({
    ThemeMode? themeMode,
    double? fontScale,
    String? fontFamily,
    Color? seedColor,
    String? localeCode,
    bool? sfxOn,
    bool? musicOn,
  }) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        fontScale: fontScale ?? this.fontScale,
        fontFamily: fontFamily ?? this.fontFamily,
        seedColor: seedColor ?? this.seedColor,
        localeCode: localeCode ?? this.localeCode,
        sfxOn: sfxOn ?? this.sfxOn,
        musicOn: musicOn ?? this.musicOn,
      );
}