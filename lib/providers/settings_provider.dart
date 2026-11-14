import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import '../services/preferences_service.dart';
import 'preferences_provider.dart';

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AppSettings> {
  late PreferencesService _prefs;

  @override
  AppSettings build() {
    _prefs = ref.watch(preferencesServiceProvider);
    return _prefs.loadSettings();
  }

  void setThemeMode(ThemeMode mode) => _update(state.copyWith(themeMode: mode));
  void setFontScale(double v) => _update(state.copyWith(fontScale: v));
  void setFontFamily(String f) => _update(state.copyWith(fontFamily: f));
  void setSeedColor(Color c) => _update(state.copyWith(seedColor: c));
  void setLocale(Locale l) => _update(state.copyWith(localeCode: l.languageCode));
  void setSfx(bool on) => _update(state.copyWith(sfxOn: on));
  void setMusic(bool on) => _update(state.copyWith(musicOn: on));

  void _update(AppSettings next) {
    state = next;
    _prefs.saveSettings(next);
  }
}