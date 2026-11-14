import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import '../services/sound_service.dart';
import 'settings_provider.dart';

/// Serviço de som; acompanha as configurações "efeitos" e "música".
final soundServiceProvider = Provider<SoundService>((ref) {
  final s = ref.read(settingsProvider);
  final service = SoundService()..sfxEnabled = s.sfxOn;
  if (s.musicOn) service.setMusic(true);
  ref.listen<AppSettings>(settingsProvider, (prev, next) {
    service.sfxEnabled = next.sfxOn;
    if (prev?.musicOn != next.musicOn) service.setMusic(next.musicOn);
  });
  ref.onDispose(service.dispose);
  return service;
});

/// Liga/desliga os EFEITOS sonoros (salva e toca um "blip" ao ligar).
void setSfxEnabled(WidgetRef ref, bool on) {
  ref.read(settingsProvider.notifier).setSfx(on);
  final service = ref.read(soundServiceProvider);
  service.sfxEnabled = on;
  if (on) service.play(SoundEffect.toggleOn);
}

/// Liga/desliga a MÚSICA de fundo (salva e começa/para o loop).
void setMusicEnabled(WidgetRef ref, bool on) {
  ref.read(settingsProvider.notifier).setMusic(on);
  ref.read(soundServiceProvider).setMusic(on);
}