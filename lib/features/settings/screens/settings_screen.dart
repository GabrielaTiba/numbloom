import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/supported_languages.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/sound_provider.dart';
import '../../../shared/widgets/language_flag_button.dart';
import '../../../shared/widgets/pixel_button.dart';
import '../../../shared/widgets/wood_panel.dart';
import '../widgets/font_family_picker.dart';
import '../widgets/seed_color_picker.dart';

/// Configurações: tema, tamanho e tipo da fonte, cor semente, idioma, som.
/// Tudo persistido em SharedPreferences via Riverpod.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  /// Altura aproximada de cada painel (na ordem de [panels]); usada para
  /// equilibrar as duas colunas em telas largas.
  static const _weights = [1.0, 1.3, 1.5, 2.2, 1.1, 2.2, 1.4];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final email = ref.watch(authStateProvider).value?.email;
    final currentLang = Localizations.localeOf(context).languageCode;

    final panels = <Widget>[
      WoodPanel(
        title: l.settingsTheme,
        child: SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
                value: ThemeMode.system,
                icon: const Icon(Icons.brightness_auto),
                label: Text(l.themeSystem)),
            ButtonSegment(
                value: ThemeMode.light,
                icon: const Icon(Icons.light_mode),
                label: Text(l.themeLight)),
            ButtonSegment(
                value: ThemeMode.dark,
                icon: const Icon(Icons.dark_mode),
                label: Text(l.themeDark)),
          ],
          selected: {s.themeMode},
          onSelectionChanged: (v) => n.setThemeMode(v.first),
        ),
      ),
      WoodPanel(
        title: l.settingsFontSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Slider(
              value: s.fontScale,
              min: 0.8,
              max: 1.6,
              divisions: 8,
              label: '${(s.fontScale * 100).round()}%',
              onChanged: n.setFontScale,
            ),
            Text(l.settingsFontPreview),
          ],
        ),
      ),
      WoodPanel(
        title: l.settingsFontFamily,
        child: FontFamilyPicker(
            selected: s.fontFamily, onChanged: n.setFontFamily),
      ),
      WoodPanel(
        title: l.settingsSeedColor,
        child:
            SeedColorPicker(selected: s.seedColor, onChanged: n.setSeedColor),
      ),
      WoodPanel(
        title: l.settingsLanguage,
        child: Wrap(
          spacing: 10,
          children: [
            for (final lang in SupportedLanguages.all)
              LanguageFlagButton(
                language: lang,
                selected: lang.locale.languageCode == currentLang,
                onTap: () => n.setLocale(lang.locale),
              ),
          ],
        ),
      ),
      WoodPanel(
        title: l.settingsSound,
        child: Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.music_note),
              title: Text(l.settingsMusic),
              subtitle: Text(l.settingsMusicSubtitle),
              value: s.musicOn,
              onChanged: (v) => setMusicEnabled(ref, v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.volume_up),
              title: Text(l.settingsEffects),
              subtitle: Text(l.settingsEffectsSubtitle),
              value: s.sfxOn,
              onChanged: (v) => setSfxEnabled(ref, v),
            ),
          ],
        ),
      ),
      WoodPanel(
        title: l.settingsAccount,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (email != null) Text(l.settingsSignedInAs(email)),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: PixelButton(
                label: l.settingsSignOut,
                icon: const Icon(Icons.logout),
                onPressed: () => ref.read(authServiceProvider).signOut(),
              ),
            ),
          ],
        ),
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: _PanelGrid(weights: _weights, children: panels),
        ),
      ),
    );
  }
}

/// Uma coluna no celular; duas colunas INDEPENDENTES em telas largas.
/// (Antes era um Wrap: cada linha ficava com a altura do painel mais alto,
/// abrindo espaço extra entre os painéis da esquerda.) Aqui cada painel vai
/// para a coluna mais baixa e todos têm o mesmo espaço entre si.
class _PanelGrid extends StatelessWidget {
  const _PanelGrid({required this.children, required this.weights});

  final List<Widget> children;
  final List<double> weights;

  static const double _gap = 12;
  static const double _columnGap = 16;

  List<Widget> _spaced(List<Widget> items) => [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: _gap),
          items[i],
        ],
      ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth < 900) {
        return Column(children: _spaced(children));
      }
      final left = <Widget>[];
      final right = <Widget>[];
      var leftHeight = 0.0;
      var rightHeight = 0.0;
      for (var i = 0; i < children.length; i++) {
        final w = i < weights.length ? weights[i] : 1.0;
        if (leftHeight <= rightHeight) {
          left.add(children[i]);
          leftHeight += w;
        } else {
          right.add(children[i]);
          rightHeight += w;
        }
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(children: _spaced(left))),
          const SizedBox(width: _columnGap),
          Expanded(child: Column(children: _spaced(right))),
        ],
      );
    });
  }
}