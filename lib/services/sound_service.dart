import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

enum SoundEffect { tap, toggleOn, success, error, bloom }

/// Som SINTETIZADO em código (nenhum arquivo de áudio):
///  * efeitos sonoros curtos (ondas "chiptune");
///  * música de fundo: loop suave de 8 compassos (harpa + baixo).
/// Efeitos e música são independentes e AMBOS começam desligados.
///
/// Pensado para celular: navegadores móveis (principalmente o Safari do
/// iPhone) só deixam o som tocar se o `play()` for chamado NO MESMO instante
/// do toque. Por isso os efeitos são gerados já na criação, a música é
/// preparada em segundo plano logo no primeiro toque, e nenhum `await` fica
/// entre o toque e o `play()`.
class SoundService {
  SoundService() {
    for (final e in SoundEffect.values) {
      _cache[e] = _synthesizeEffect(e); // curtíssimos: custo desprezível
    }
  }

  bool sfxEnabled = false;

  AudioPlayer? _sfx;
  AudioPlayer? _music;
  final Map<SoundEffect, Uint8List> _cache = {};

  Uint8List? _musicBytes;
  Future<Uint8List>? _musicFuture;

  bool _musicWanted = false;
  bool _musicPlaying = false;
  bool _musicStarting = false;
  bool _gestureResumed = false;
  bool _warm = false;

  static const int _rate = 22050;

  AudioPlayer get _sfxPlayer => _sfx ??= AudioPlayer();

  AudioPlayer get _musicPlayer => _music ??= (AudioPlayer()
    ..setReleaseMode(ReleaseMode.loop)
    ..setVolume(0.3));

  // ---------------------------------------------------------------- efeitos

  // (frequência em Hz, duração em segundos)
  static const Map<SoundEffect, List<(double, double)>> _notes = {
    SoundEffect.tap: [(880.0, 0.04)],
    SoundEffect.toggleOn: [(660.0, 0.06), (990.0, 0.09)],
    SoundEffect.success: [
      (523.25, 0.09),
      (659.25, 0.09),
      (783.99, 0.09),
      (1046.5, 0.22),
    ],
    SoundEffect.error: [(233.08, 0.12), (174.61, 0.2)],
    SoundEffect.bloom: [
      (783.99, 0.08),
      (987.77, 0.08),
      (1174.66, 0.08),
      (1567.98, 0.3),
    ],
  };

  Future<void> play(SoundEffect effect) async {
    if (!sfxEnabled) return;
    try {
      // Sem "await" antes: o play() acontece no instante do toque.
      await _sfxPlayer.play(BytesSource(_cache[effect]!, mimeType: 'audio/wav'));
    } catch (_) {
      // Som é opcional: qualquer falha de áudio é ignorada em silêncio.
    }
  }

  // ----------------------------------------------------------------- música

  Future<Uint8List> _musicData() => _musicFuture ??=
      _synthesizeMusic().then((bytes) => _musicBytes = bytes);

  /// Prepara a música em segundo plano (chamado ~2 s depois do 1º toque), para
  /// que ligar a música depois toque sem espera.
  void warmUp() {
    if (_warm) return;
    _warm = true;
    Future<void>.delayed(const Duration(seconds: 2), () {
      _musicData();
    });
  }

  /// Liga/desliga a música de fundo (em loop).
  Future<void> setMusic(bool on) async {
    _musicWanted = on;
    if (on) {
      _gestureResumed = true; // veio de um clique do usuário
      await _startMusic();
    } else {
      _musicPlaying = false;
      try {
        await _music?.stop();
      } catch (_) {}
    }
  }

  Future<void> _startMusic() async {
    if (!_musicWanted || _musicPlaying || _musicStarting) return;
    _musicStarting = true;
    try {
      // Se já está preparada, não há nenhuma espera antes do play().
      final bytes = _musicBytes ?? await _musicData();
      if (!_musicWanted) return;
      await _musicPlayer.play(BytesSource(bytes, mimeType: 'audio/wav'));
      _musicPlaying = true;
    } catch (_) {
      _musicPlaying = false; // o navegador pode bloquear: tenta no próximo toque
    } finally {
      _musicStarting = false;
    }
  }

  /// Chamado a cada toque na tela. Navegadores bloqueiam áudio automático:
  /// se a música estava salva como "ligada", ela começa no primeiro toque.
  void ensureMusic() {
    if (!_musicWanted) return;
    if (!_musicPlaying) {
      _startMusic();
    } else if (!_gestureResumed) {
      _gestureResumed = true;
      _music?.resume();
    }
  }

  Future<void> pauseMusic() async {
    if (!_musicPlaying) return;
    try {
      await _music?.pause();
    } catch (_) {}
  }

  Future<void> resumeMusic() async {
    if (!_musicWanted) return;
    if (_musicPlaying) {
      try {
        await _music?.resume();
      } catch (_) {}
    } else {
      await _startMusic();
    }
  }

  Future<void> dispose() async {
    await _sfx?.dispose();
    await _music?.dispose();
    _sfx = null;
    _music = null;
  }

  // -------------------------------------------------------------- síntese

  static Uint8List _synthesizeEffect(SoundEffect effect) {
    final samples = <int>[];
    for (final (freq, secs) in _notes[effect]!) {
      final count = (_rate * secs).round();
      var phase = 0.0;
      for (var i = 0; i < count; i++) {
        final t = i / count;
        final attack = i < 120 ? i / 120 : 1.0; // evita "estalo" no início
        final env = attack * math.pow(1 - t, 1.5).toDouble();
        phase += freq / _rate;
        final square = (phase % 1.0) < 0.5 ? 1.0 : -1.0;
        final v = (square * 0.55 + math.sin(2 * math.pi * phase) * 0.45) *
            env *
            0.35;
        samples.add((v * 32767).round().clamp(-32768, 32767));
      }
    }
    return _encodeWav(Int16List.fromList(samples));
  }

  /// Loop de 8 compassos (C – Am – F – G, duas vezes), 92 bpm: arpejo de
  /// "harpa" + baixo + melodia esparsa. As notas que passam do fim do loop
  /// voltam ao início (módulo), então a emenda do loop é contínua.
  static Future<Uint8List> _synthesizeMusic() async {
    const bpm = 92.0;
    const beat = 60.0 / bpm;
    const bars = 8;
    final total = (_rate * beat * 4 * bars).round();
    final mix = Float64List(total);

    void pluck(double start, double freq, double amp,
        {required double decay, required double dur}) {
      final s0 = (start * _rate).round();
      final n = (dur * _rate).round();
      for (var i = 0; i < n; i++) {
        final t = i / _rate;
        final env = (i < 110 ? i / 110 : 1.0) * math.exp(-t * decay);
        final w = math.sin(2 * math.pi * freq * t) +
            0.28 * math.sin(4 * math.pi * freq * t);
        mix[(s0 + i) % total] += w * env * amp;
      }
    }

    const chords = [
      [261.63, 329.63, 392.00, 523.25], // C
      [220.00, 261.63, 329.63, 440.00], // Am
      [349.23, 440.00, 523.25, 698.46], // F
      [392.00, 493.88, 587.33, 783.99], // G
    ];
    const bass = [130.81, 110.00, 87.31, 98.00];
    const arp = [0, 1, 2, 3, 2, 1, 2, 1];
    const melody = [
      [659.25, 783.99],
      [440.00, 523.25],
      [523.25, 440.00],
      [587.33, 493.88],
      [659.25, 783.99],
      [440.00, 659.25],
      [523.25, 440.00],
      [587.33, 493.88],
    ];

    for (var bar = 0; bar < bars; bar++) {
      final c = bar % 4;
      final t0 = bar * 4 * beat;
      for (var k = 0; k < 8; k++) {
        pluck(t0 + k * beat / 2, chords[c][arp[k]], 0.16, decay: 6.0, dur: 0.9);
      }
      pluck(t0, bass[c], 0.30, decay: 1.6, dur: 2.2);
      pluck(t0 + 2 * beat, bass[c], 0.22, decay: 1.6, dur: 2.0);
      pluck(t0, melody[bar][0], 0.20, decay: 3.2, dur: 1.8);
      pluck(t0 + 2 * beat, melody[bar][1], 0.18, decay: 3.2, dur: 1.8);
      await Future<void>.delayed(Duration.zero); // não trava a interface
    }

    var peak = 0.0;
    for (final v in mix) {
      if (v.abs() > peak) peak = v.abs();
    }
    final scale = peak == 0 ? 0.0 : 0.7 * 32767 / peak;
    final pcm = Int16List(total);
    for (var i = 0; i < total; i++) {
      pcm[i] = (mix[i] * scale).round().clamp(-32768, 32767);
    }
    return _encodeWav(pcm);
  }

  static Uint8List _encodeWav(Int16List samples) {
    final dataSize = samples.length * 2;
    final b = ByteData(44 + dataSize);
    void tag(int o, String s) {
      for (var i = 0; i < s.length; i++) {
        b.setUint8(o + i, s.codeUnitAt(i));
      }
    }

    tag(0, 'RIFF');
    b.setUint32(4, 36 + dataSize, Endian.little);
    tag(8, 'WAVE');
    tag(12, 'fmt ');
    b.setUint32(16, 16, Endian.little);
    b.setUint16(20, 1, Endian.little); // PCM
    b.setUint16(22, 1, Endian.little); // mono
    b.setUint32(24, _rate, Endian.little);
    b.setUint32(28, _rate * 2, Endian.little);
    b.setUint16(32, 2, Endian.little);
    b.setUint16(34, 16, Endian.little);
    tag(36, 'data');
    b.setUint32(40, dataSize, Endian.little);
    for (var i = 0; i < samples.length; i++) {
      b.setInt16(44 + i * 2, samples[i], Endian.little);
    }
    return b.buffer.asUint8List();
  }
}