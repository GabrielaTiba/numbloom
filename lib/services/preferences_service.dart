import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/game/game_level.dart';
import '../core/theme/app_colors.dart';
import '../models/app_settings.dart';
import '../models/game_session.dart';

/// Leitura/escrita em SharedPreferences: configurações e última página.
class PreferencesService {
  PreferencesService(this._p);

  final SharedPreferences _p;

  static const _kThemeMode = 'settings.themeMode';
  static const _kFontScale = 'settings.fontScale';
  static const _kFontFamily = 'settings.fontFamily';
  static const _kSeed = 'settings.seedColor';
  static const _kLocale = 'settings.locale';
  static const _kSound = 'settings.sound'; // efeitos sonoros
  static const _kMusic = 'settings.music';
  static const _kLastRoute = 'nav.lastRoute';
  static const _kLevel = 'game.level';

  AppSettings loadSettings() {
    final modeName = _p.getString(_kThemeMode);
    final mode = ThemeMode.values.firstWhere(
      (m) => m.name == modeName,
      orElse: () => ThemeMode.system,
    );
    final seed = _p.getInt(_kSeed);
    return AppSettings(
      themeMode: mode,
      fontScale: _p.getDouble(_kFontScale) ?? 1.0,
      fontFamily: _p.getString(_kFontFamily) ?? 'Roboto',
      seedColor: seed == null ? NumBloomColors.moss : Color(seed),
      localeCode: _p.getString(_kLocale),
      sfxOn: _p.getBool(_kSound) ?? false,
      musicOn: _p.getBool(_kMusic) ?? false,
    );
  }

  Future<void> saveSettings(AppSettings s) async {
    await _p.setString(_kThemeMode, s.themeMode.name);
    await _p.setDouble(_kFontScale, s.fontScale);
    await _p.setString(_kFontFamily, s.fontFamily);
    await _p.setInt(_kSeed, s.seedColor.toARGB32());
    if (s.localeCode == null) {
      await _p.remove(_kLocale);
    } else {
      await _p.setString(_kLocale, s.localeCode!);
    }
    await _p.setBool(_kSound, s.sfxOn);
    await _p.setBool(_kMusic, s.musicOn);
  }

  GameLevel get gameLevel {
    final name = _p.getString(_kLevel);
    return GameLevel.values.firstWhere(
      (l) => l.name == name,
      orElse: () => GameLevel.easy,
    );
  }

  Future<void> setGameLevel(GameLevel level) =>
      _p.setString(_kLevel, level.name);

  // ---- Partida em andamento (uma por usuário) ----

  String _sessionKey(String uid) => 'game.session.$uid';

  GameSession? loadGameSession(String uid) =>
      GameSession.decode(_p.getString(_sessionKey(uid)));

  Future<void> saveGameSession(String uid, GameSession session) =>
      _p.setString(_sessionKey(uid), session.encode());

  /// Última aba aberta (ex.: "/progress"); restaurada ao reabrir o app.
  String? get lastRoute => _p.getString(_kLastRoute);

  Future<void> setLastRoute(String route) async {
    if (_p.getString(_kLastRoute) == route) return;
    await _p.setString(_kLastRoute, route);
  }
}