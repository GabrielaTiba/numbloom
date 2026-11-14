import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/settings_provider.dart';
import '../../../providers/sound_provider.dart';
import 'title_controls.dart';

/// TitleControls ligado ao Riverpod (configurações persistidas).
class ConnectedControls extends ConsumerWidget {
  const ConnectedControls({
    super.key,
    this.showLanguage = true,
    this.buttonSize = 54,
  });

  final bool showLanguage;
  final double buttonSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TitleControls(
      showLanguage: showLanguage,
      buttonSize: buttonSize,
      locale: Localizations.localeOf(context),
      onLocaleChanged: notifier.setLocale,
      isDark: isDark,
      onToggleTheme: () =>
          notifier.setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark),
      musicOn: settings.musicOn,
      onToggleMusic: () => setMusicEnabled(ref, !settings.musicOn),
      sfxOn: settings.sfxOn,
      onToggleSfx: () => setSfxEnabled(ref, !settings.sfxOn),
    );
  }
}