import 'game_level.dart';
import 'operator_kind.dart';
import 'expression_parser.dart';

/// Converte a expressão do jogador em LaTeX (para o flutter_math_fork).
/// Expressão válida -> LaTeX estruturado (frações, raízes, expoentes).
/// Expressão incompleta -> renderização "tolerante" peça a peça, sempre
/// com delimitadores balanceados para o KaTeX nunca falhar.
class LatexBuilder {
  const LatexBuilder._();

  static String fromTokens(List<ExprToken> tokens, GameLevel level) {
    if (tokens.isEmpty) return '';
    try {
      final eq = ExpressionParser.parseEquation(tokens, level);
      return '${_node(eq.left)} = ${_node(eq.right)}';
    } on ExpressionException {
      return _partial(tokens, level);
    }
  }

  /// Fórmula ainda incompleta (sem "=", ou com um lado inválido): tenta
  /// renderizar CADA LADO de forma estruturada (raízes, expoentes, frações);
  /// só o que não puder ser interpretado cai na versão "peça a peça".
  static String _partial(List<ExprToken> tokens, GameLevel level) {
    final eq = [
      for (var i = 0; i < tokens.length; i++)
        if (tokens[i].op == OperatorKind.equals) i,
    ];
    if (eq.isEmpty) return _side(tokens, level);
    if (eq.length == 1) {
      final k = eq.first;
      final left = _side(tokens.sublist(0, k), level);
      final right = _side(tokens.sublist(k + 1), level);
      return right.isEmpty ? '$left =' : '$left = $right';
    }
    return _lenient(tokens);
  }

  static String _side(List<ExprToken> tokens, GameLevel level) {
    if (tokens.isEmpty) return '';
    try {
      return _node(ExpressionParser.parseExpression(tokens, level));
    } on ExpressionException {
      return _lenient(tokens);
    }
  }

  static String _node(Node n) {
    if (n is NumNode) return n.text;
    if (n is GroupNode) return r'\left(' + _node(n.inner) + r'\right)';
    if (n is UnaryNode) return '${n.negate ? '-' : '+'}${_node(n.operand)}';
    if (n is BinaryNode) return _binary(n);
    if (n is FuncNode) return _func(n);
    return '';
  }

  static String _wrapIfUnary(Node n) =>
      n is UnaryNode ? r'\left(' + _node(n) + r'\right)' : _node(n);

  static String _binary(BinaryNode n) {
    switch (n.op) {
      case OperatorKind.add:
        return '${_node(n.left)} + ${_wrapIfUnary(n.right)}';
      case OperatorKind.subtract:
        return '${_node(n.left)} - ${_wrapIfUnary(n.right)}';
      case OperatorKind.multiply:
        return '${_node(n.left)} \\cdot ${_wrapIfUnary(n.right)}';
      case OperatorKind.divide:
        return '\\frac{${_node(n.left)}}{${_node(n.right)}}';
      case OperatorKind.power:
        return '${_powerBase(n.left)}^{${_node(n.right)}}';
      default:
        return '';
    }
  }

  static String _powerBase(Node n) {
    final needsParens = n is UnaryNode ||
        n is BinaryNode ||
        (n is FuncNode && n.op == OperatorKind.factorial);
    return needsParens ? r'\left(' + _node(n) + r'\right)' : _node(n);
  }

  static String _unwrap(Node n) => n is GroupNode ? _node(n.inner) : _node(n);

  static String _func(FuncNode n) {
    switch (n.op) {
      case OperatorKind.sqrt:
        return '\\sqrt{${_unwrap(n.arg)}}';
      case OperatorKind.cbrt:
        return '\\sqrt[3]{${_unwrap(n.arg)}}';
      case OperatorKind.factorial:
        final a = n.arg;
        final isRoot = a is FuncNode &&
            (a.op == OperatorKind.sqrt || a.op == OperatorKind.cbrt);
        return isRoot
            ? r'\left(' + _node(a) + r'\right)!'
            : '${_node(a)}!';
      case OperatorKind.absOpen:
        return '\\left|${_node(n.arg)}\\right|';
      case OperatorKind.floorOpen:
        return '\\left\\lfloor ${_node(n.arg)} \\right\\rfloor';
      case OperatorKind.ceilOpen:
        return '\\left\\lceil ${_node(n.arg)} \\right\\rceil';
      default:
        return '';
    }
  }

  static String _lenient(List<ExprToken> tokens) {
    final b = StringBuffer();
    for (final t in tokens) {
      if (t.isDigit) {
        b.write(t.digit);
        continue;
      }
      switch (t.op!) {
        case OperatorKind.add:
          b.write(' + ');
        case OperatorKind.subtract:
          b.write(' - ');
        case OperatorKind.multiply:
          b.write(r' \cdot ');
        case OperatorKind.divide:
          b.write(r' \div ');
        case OperatorKind.parenOpen:
          b.write('(');
        case OperatorKind.parenClose:
          b.write(')');
        case OperatorKind.sqrt:
          b.write(r'\surd ');
        case OperatorKind.cbrt:
          b.write(r'{}^{3}\surd ');
        case OperatorKind.factorial:
          b.write('!');
        case OperatorKind.power:
          b.write(r' \mathbin{\ast\ast} ');
        case OperatorKind.absOpen:
        case OperatorKind.absClose:
          b.write('|');
        case OperatorKind.floorOpen:
          b.write(r'\lfloor ');
        case OperatorKind.floorClose:
          b.write(r'\rfloor ');
        case OperatorKind.ceilOpen:
          b.write(r'\lceil ');
        case OperatorKind.ceilClose:
          b.write(r'\rceil ');
        case OperatorKind.equals:
          b.write(' = ');
      }
    }
    return b.toString();
  }
}