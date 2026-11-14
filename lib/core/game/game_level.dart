import 'operator_kind.dart';

/// Níveis de dificuldade e seus operadores (conforme o enunciado).
enum GameLevel {
  easy,
  intermediate,
  advanced,
  hard;

  static const Set<OperatorKind> _base = {
    OperatorKind.add,
    OperatorKind.subtract,
    OperatorKind.multiply,
    OperatorKind.divide,
    OperatorKind.parenOpen,
    OperatorKind.parenClose,
    OperatorKind.absOpen,
    OperatorKind.absClose,
  };

  /// Fácil: único nível que aceita resultados não inteiros (ex.: 5/2).
  bool get allowsNonIntegerResults => this == GameLevel.easy;

  /// Operadores disponíveis (sem contar o `=`, sempre disponível).
  Set<OperatorKind> get allowedOperators {
    switch (this) {
      case GameLevel.easy:
        return {
          ..._base,
          OperatorKind.sqrt,
          OperatorKind.cbrt,
          OperatorKind.factorial,
          OperatorKind.power,
          OperatorKind.floorOpen,
          OperatorKind.floorClose,
          OperatorKind.ceilOpen,
          OperatorKind.ceilClose,
        };
      case GameLevel.intermediate:
        return {
          ..._base,
          OperatorKind.sqrt,
          OperatorKind.cbrt,
          OperatorKind.factorial,
          OperatorKind.power,
        };
      case GameLevel.advanced:
        return {
          ..._base,
          OperatorKind.sqrt,
          OperatorKind.factorial,
        };
      case GameLevel.hard:
        return {..._base};
    }
  }

  /// Pontos ganhos por número resolvido neste nível.
  int get points {
    switch (this) {
      case GameLevel.easy:
        return 10;
      case GameLevel.intermediate:
        return 20;
      case GameLevel.advanced:
        return 35;
      case GameLevel.hard:
        return 60;
    }
  }

  bool allows(OperatorKind kind) =>
      kind == OperatorKind.equals || allowedOperators.contains(kind);
}