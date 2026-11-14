import 'dart:convert';

import '../core/game/game_level.dart';

/// Partida em andamento, guardada no aparelho (SharedPreferences) para o app
/// voltar de onde parou: nível, número sorteado e operadores já colocados.
class GameSession {
  const GameSession({
    required this.level,
    required this.number,
    required this.gaps,
  });

  final GameLevel level;
  final int number;

  /// Nomes dos operadores em cada um dos 5 espaços.
  final List<List<String>> gaps;

  String encode() =>
      jsonEncode({'level': level.name, 'number': number, 'gaps': gaps});

  /// Devolve null se o texto salvo estiver ausente ou corrompido.
  static GameSession? decode(String? raw) {
    if (raw == null) return null;
    try {
      final m = jsonDecode(raw);
      if (m is! Map) return null;
      final levelName = m['level'];
      final number = m['number'];
      final g = m['gaps'];
      if (levelName is! String || number is! int || g is! List) return null;
      final levels = GameLevel.values.where((l) => l.name == levelName);
      if (levels.isEmpty) return null;
      final gaps = [
        for (final row in g)
          if (row is List) [for (final e in row) if (e is String) e],
      ];
      return GameSession(level: levels.first, number: number, gaps: gaps);
    } catch (_) {
      return null;
    }
  }
}