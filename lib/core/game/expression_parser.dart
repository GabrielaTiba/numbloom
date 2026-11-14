import 'game_level.dart';
import 'operator_kind.dart';

enum ExpressionErrorCode {
  empty,
  missingEquals,
  multipleEquals,
  unexpectedToken,
  unexpectedEnd,
  unbalanced,
  operatorNotAllowed,
  divisionByZero,
  nonIntegerDivision,
  negativeSqrt,
  nonIntegerRoot,
  invalidFactorial,
  nonIntegerResult,
  overflow,
  invalidPower,
}

/// Erro de sintaxe ou de domínio. A UI traduz o [code] via l10n.
class ExpressionException implements Exception {
  const ExpressionException(this.code, {this.position});
  final ExpressionErrorCode code;

  /// Índice da peça problemática na lista de tokens (quando conhecido).
  final int? position;

  @override
  String toString() => 'ExpressionException($code, position: $position)';
}

// ---------------------------------------------------------------- AST

abstract class Node {
  const Node();
}

class NumNode extends Node {
  const NumNode(this.value, this.text);
  final double value;
  final String text;
}

/// Parênteses digitados pelo usuário (preservados para o LaTeX).
class GroupNode extends Node {
  const GroupNode(this.inner);
  final Node inner;
}

class UnaryNode extends Node {
  const UnaryNode(this.negate, this.operand);
  final bool negate;
  final Node operand;
}

/// op ∈ {add, subtract, multiply, divide, power}
class BinaryNode extends Node {
  const BinaryNode(this.op, this.left, this.right);
  final OperatorKind op;
  final Node left;
  final Node right;
}

/// op ∈ {sqrt, cbrt, factorial, absOpen (=módulo), floorOpen, ceilOpen}
class FuncNode extends Node {
  const FuncNode(this.op, this.arg);
  final OperatorKind op;
  final Node arg;
}

class ParsedEquation {
  const ParsedEquation(this.left, this.right);
  final Node left;
  final Node right;
}

// ------------------------------------------------------------- Parser

/// Gramática (precedência crescente):
///   expr    := term (('+'|'-') term)*
///   term    := unary (('*'|'/') unary)*
///   unary   := ('-'|'+') unary | power
///   power   := postfix ('**' unary)?          (associativo à direita)
///   postfix := primary '!'*
///   primary := número | '(' expr ')' | '|' expr '|' | '⌊' expr '⌋'
///            | '⌈' expr '⌉' | ('√'|'∛') postfix
/// Raiz prefixa: √9! = √(9!); (√4)! exige parênteses.
/// Não há multiplicação implícita: "2(3)" é erro.
class ExpressionParser {
  const ExpressionParser._();

  /// Analisa uma expressão SEM igualdade (um lado só). Usada para mostrar o
  /// LaTeX estruturado enquanto o jogador ainda monta a fórmula.
  static Node parseExpression(List<ExprToken> tokens, GameLevel level) {
    if (tokens.isEmpty) {
      throw const ExpressionException(ExpressionErrorCode.empty);
    }
    for (var i = 0; i < tokens.length; i++) {
      final op = tokens[i].op;
      if (op != null && !level.allows(op)) {
        throw ExpressionException(ExpressionErrorCode.operatorNotAllowed,
            position: i);
      }
    }
    return _SideParser(tokens, 0).parseAll();
  }

  static ParsedEquation parseEquation(
      List<ExprToken> tokens, GameLevel level) {
    if (tokens.isEmpty) {
      throw const ExpressionException(ExpressionErrorCode.empty);
    }
    for (var i = 0; i < tokens.length; i++) {
      final op = tokens[i].op;
      if (op != null && !level.allows(op)) {
        throw ExpressionException(ExpressionErrorCode.operatorNotAllowed,
            position: i);
      }
    }
    final eq = [
      for (var i = 0; i < tokens.length; i++)
        if (tokens[i].op == OperatorKind.equals) i
    ];
    if (eq.isEmpty) {
      throw const ExpressionException(ExpressionErrorCode.missingEquals);
    }
    if (eq.length > 1) {
      throw ExpressionException(ExpressionErrorCode.multipleEquals,
          position: eq[1]);
    }
    final k = eq.first;
    final left = _SideParser(tokens.sublist(0, k), 0).parseAll();
    final right = _SideParser(tokens.sublist(k + 1), k + 1).parseAll();
    return ParsedEquation(left, right);
  }
}

class _SideParser {
  _SideParser(this._t, this._offset);

  final List<ExprToken> _t;
  final int _offset;
  int _i = 0;

  ExprToken? get _cur => _i < _t.length ? _t[_i] : null;
  OperatorKind? get _curOp => _cur?.op;
  int get _pos => _offset + _i;

  Node parseAll() {
    if (_t.isEmpty) {
      throw ExpressionException(ExpressionErrorCode.unexpectedEnd,
          position: _offset);
    }
    final n = _expr();
    if (_i < _t.length) {
      final op = _curOp;
      final closing = op == OperatorKind.parenClose ||
          op == OperatorKind.absClose ||
          op == OperatorKind.floorClose ||
          op == OperatorKind.ceilClose;
      throw ExpressionException(
          closing
              ? ExpressionErrorCode.unbalanced
              : ExpressionErrorCode.unexpectedToken,
          position: _pos);
    }
    return n;
  }

  Node _expr() {
    var left = _term();
    while (_curOp == OperatorKind.add || _curOp == OperatorKind.subtract) {
      final op = _curOp!;
      _i++;
      left = BinaryNode(op, left, _term());
    }
    return left;
  }

  Node _term() {
    var left = _unary();
    while (_curOp == OperatorKind.multiply || _curOp == OperatorKind.divide) {
      final op = _curOp!;
      _i++;
      left = BinaryNode(op, left, _unary());
    }
    return left;
  }

  Node _unary() {
    if (_curOp == OperatorKind.subtract || _curOp == OperatorKind.add) {
      final negate = _curOp == OperatorKind.subtract;
      _i++;
      return UnaryNode(negate, _unary());
    }
    return _power();
  }

  Node _power() {
    final base = _postfix();
    if (_curOp == OperatorKind.power) {
      _i++;
      return BinaryNode(OperatorKind.power, base, _unary());
    }
    return base;
  }

  Node _postfix() {
    var n = _primary();
    while (_curOp == OperatorKind.factorial) {
      _i++;
      n = FuncNode(OperatorKind.factorial, n);
    }
    return n;
  }

  Node _primary() {
    final tok = _cur;
    if (tok == null) {
      throw ExpressionException(ExpressionErrorCode.unexpectedEnd,
          position: _pos);
    }
    if (tok.isDigit) {
      final buf = StringBuffer();
      while (_cur != null && _cur!.isDigit) {
        buf.write(_cur!.digit);
        _i++;
      }
      final text = buf.toString();
      return NumNode(double.parse(text), text);
    }
    switch (tok.op!) {
      case OperatorKind.parenOpen:
        _i++;
        final inner = _expr();
        _expect(OperatorKind.parenClose);
        return GroupNode(inner);
      case OperatorKind.absOpen:
        _i++;
        final inner = _expr();
        _expect(OperatorKind.absClose);
        return FuncNode(OperatorKind.absOpen, inner);
      case OperatorKind.floorOpen:
        _i++;
        final inner = _expr();
        _expect(OperatorKind.floorClose);
        return FuncNode(OperatorKind.floorOpen, inner);
      case OperatorKind.ceilOpen:
        _i++;
        final inner = _expr();
        _expect(OperatorKind.ceilClose);
        return FuncNode(OperatorKind.ceilOpen, inner);
      case OperatorKind.sqrt:
      case OperatorKind.cbrt:
        final op = tok.op!;
        _i++;
        return FuncNode(op, _postfix());
      default:
        throw ExpressionException(ExpressionErrorCode.unexpectedToken,
            position: _pos);
    }
  }

  void _expect(OperatorKind close) {
    if (_curOp != close) {
      throw ExpressionException(ExpressionErrorCode.unbalanced,
          position: _pos);
    }
    _i++;
  }
}