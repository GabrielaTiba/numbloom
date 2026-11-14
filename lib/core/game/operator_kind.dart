/// Todos os operadores/delimitadores que o jogador pode usar.
/// `equals` é sempre permitido (exatamente um por expressão).
enum OperatorKind {
  add,
  subtract,
  multiply,
  divide,
  parenOpen,
  parenClose,
  sqrt,
  cbrt,
  factorial,
  power,
  absOpen,
  absClose,
  floorOpen,
  floorClose,
  ceilOpen,
  ceilClose,
  equals;

  /// Símbolo exibido nas peças da interface.
  String get symbol {
    switch (this) {
      case OperatorKind.add:
        return '+';
      case OperatorKind.subtract:
        return '−';
      case OperatorKind.multiply:
        return '×';
      case OperatorKind.divide:
        return '÷';
      case OperatorKind.parenOpen:
        return '(';
      case OperatorKind.parenClose:
        return ')';
      case OperatorKind.sqrt:
        return '√';
      case OperatorKind.cbrt:
        return '∛';
      case OperatorKind.factorial:
        return '!';
      case OperatorKind.power:
        return '**';
      case OperatorKind.absOpen:
      case OperatorKind.absClose:
        return '|';
      case OperatorKind.floorOpen:
        return '⌊';
      case OperatorKind.floorClose:
        return '⌋';
      case OperatorKind.ceilOpen:
        return '⌈';
      case OperatorKind.ceilClose:
        return '⌉';
      case OperatorKind.equals:
        return '=';
    }
  }
}

/// Peça da expressão: um dígito do desafio ou um operador.
/// Dígitos adjacentes (sem operador entre eles) formam um número de vários
/// dígitos (ex.: 1 e 4 juntos = 14).
class ExprToken {
  const ExprToken.op(this.op) : digit = null;
  const ExprToken.digit(this.digit) : op = null;

  final OperatorKind? op;
  final String? digit;

  bool get isDigit => digit != null;

  @override
  String toString() => isDigit ? digit! : op!.symbol;
}