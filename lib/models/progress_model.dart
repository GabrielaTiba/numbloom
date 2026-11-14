import '../core/game/game_level.dart';

/// Progresso do jogador: pontuação e números resolvidos POR NÍVEL.
class ProgressModel {
  const ProgressModel({this.score = 0, this.solved = const {}});

  static const ProgressModel empty = ProgressModel();

  /// Quantidade de números de 4 dígitos possíveis (1000..9999) por nível.
  static const int totalPerLevel = 9000;

  final int score;
  final Map<GameLevel, Set<int>> solved;

  Set<int> solvedAt(GameLevel level) => solved[level] ?? const <int>{};

  int countAt(GameLevel level) => solvedAt(level).length;

  int get solvedCount =>
      GameLevel.values.fold(0, (s, l) => s + countAt(l));

  double get completion =>
      solvedCount / (totalPerLevel * GameLevel.values.length);

  ProgressModel withSolution(GameLevel level, int number, int points) {
    final next = <GameLevel, Set<int>>{
      for (final e in solved.entries) e.key: {...e.value},
    };
    (next[level] ??= <int>{}).add(number);
    return ProgressModel(score: score + points, solved: next);
  }
}

/// Uma solução guardada (histórico exibido na tela de progresso).
class SolutionRecord {
  const SolutionRecord({
    required this.number,
    required this.level,
    required this.expression,
    required this.latex,
    required this.points,
    this.solvedAt,
  });

  final int number;
  final GameLevel level;
  final String expression;
  final String latex;
  final int points;
  final DateTime? solvedAt;
}