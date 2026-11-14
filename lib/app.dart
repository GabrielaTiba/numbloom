import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';
import 'providers/settings_provider.dart';
import 'providers/sound_provider.dart';
import 'services/sound_service.dart';
import 'shared/widgets/pixel_pressable.dart';

class NumBloomApp extends ConsumerStatefulWidget {
  const NumBloomApp({super.key});

  @override
  ConsumerState<NumBloomApp> createState() => _NumBloomAppState();
}

class _NumBloomAppState extends ConsumerState<NumBloomApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Cria o serviço já na abertura (retoma a música se estava ligada).
    ref.read(soundServiceProvider);
    // Todo toque em botão/peça faz um "clique" (só se o som estiver ligado).
    PixelTapHook.onTap =
        () => ref.read(soundServiceProvider).play(SoundEffect.tap);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final sound = ref.read(soundServiceProvider);
    switch (state) {
      case AppLifecycleState.resumed:
        sound.resumeMusic();
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        sound.pauseMusic();
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    PixelTapHook.onTap = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      routerConfig: router,
      locale:
          settings.localeCode == null ? null : Locale(settings.localeCode!),
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        FirebaseUILocalizations.delegate, // textos das telas de login
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: settings.themeMode,
      theme: AppTheme.build(
        seed: settings.seedColor,
        brightness: Brightness.light,
        bodyFont: settings.fontFamily,
      ),
      darkTheme: AppTheme.build(
        seed: settings.seedColor,
        brightness: Brightness.dark,
        bodyFont: settings.fontFamily,
      ),
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        // Tamanho da fonte do usuário x escala de acessibilidade do sistema.
        final scale = settings.fontScale * mq.textScaler.scale(1.0);
        return MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(scale)),
          // Navegadores bloqueiam áudio automático: o 1º toque libera a música.
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              final sound = ref.read(soundServiceProvider);
              sound.warmUp(); // prepara a música para tocar sem espera
              sound.ensureMusic();
            },
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}