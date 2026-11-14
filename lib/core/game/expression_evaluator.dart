import 'dart:math' as math;

import 'game_level.dart';
import 'operator_kind.dart';
import 'expression_parser.dart';

class EvaluationResult {
  const EvaluationResult._({
    required this.isCorrect,
    this.leftValue,
    this.rightValue,
    this.error,
  });

  const EvaluationResult.valid({
    required bool isCorrect,
    required double left,
    required double right,
  }) : this._(isCorrect: isCorrect, leftValue: left, rightValue: right);

  const EvaluationResult.failure(ExpressionException error)
      : this._(isCorrect: false, error: error);

  final bool isCorrect;
  final double? leftValue;
  final double? rightValue;
  final ExpressionException? error;

  bool get hasError => error != null;
}

/// Avaliador próprio (sem eval): tokens -> AST -> valor.
///
/// Regras por nível:
///  * Fácil: resultados reais; igualdade com tolerância relativa de 1e-9.
///  * Demais: todo valor intermediário precisa ser inteiro. Divisão não exata,
///    raiz não exata e expoente negativo (|base| != 1) geram erro.
/// Valores acima de 1e15 geram `overflow` (garante exatidão em double,
/// inclusive no Flutter Web, onde int também é double de 53 bits).
class ExpressionEvaluator {
  const ExpressionEvaluator._();

  static EvaluationResult evaluate(List<ExprToken> tokens, GameLevel level) {
    try {
      final eq = ExpressionParser.parseEquation(tokens, level);
      final ev = _Evaluator(level);
      final l = ev.eval(eq.left);
      final r = ev.eval(eq.right);
      final ok = level.allowsNonIntegerResults
          ? (l - r).abs() <=
              1e-9 * math.max(1.0, math.max(l.abs(), r.abs()))
          : l == r;
      return EvaluationResult.valid(isCorrect: ok, left: l, right: r);
    } on ExpressionException catch (e) {
      return EvaluationResult.failure(e);
    }
  }
}

/// Formata um valor para exibição (inteiros sem casas; reais até 6 casas).
String formatNumber(double v) {
  if (v == 0) return '0';
  if (v == v.truncateToDouble() && v.abs() < 1e15) {
    return v.toInt().toString();
  }
  var s = v.toStringAsFixed(6);
  s = s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  return s;
}

class _Evaluator {
  _Evaluator(this.level);

  final GameLevel level;
  static const double _maxAbs = 1e15;

  bool get _exact => !level.allowsNonIntegerResults;

  double eval(Node n) {
    if (n is NumNode) return _check(n.value);
    if (n is GroupNode) return eval(n.inner);
    if (n is UnaryNode) {
      final v = eval(n.operand);
      return n.negate ? -v : v;
    }
    if (n is BinaryNode) return _binary(n);
    if (n is FuncNode) return _func(n);
    throw StateError('Nó desconhecido: $n');
  }

  double _check(double v) {
    if (!v.isFinite || v.abs() > _maxAbs) {
      throw const ExpressionException(ExpressionErrorCode.overflow);
    }
    return v;
  }

  bool _isInt(double v) => v == v.truncateToDouble();

  /// Remove ruído de ponto flutuante (ex.: 2.0000000000000004 -> 2).
  double _snap(double v) {
    final r = v.roundToDouble();
    return (v - r).abs() < 1e-9 ? r : v;
  }

  double _binary(BinaryNode n) {
    final l = eval(n.left);
    final r = eval(n.right);
    switch (n.op) {
      case OperatorKind.add:
        return _check(l + r);
      case OperatorKind.subtract:
        return _check(l - r);
      case OperatorKind.multiply:
        return _check(l * r);
      case OperatorKind.divide:
        if (r == 0) {
          throw const ExpressionException(ExpressionErrorCode.divisionByZero);
        }
        if (_exact && (l % r) != 0) {
          throw const ExpressionException(
              ExpressionErrorCode.nonIntegerDivision);
        }
        return _check(l / r);
      case OperatorKind.power:
        return _power(l, r);
      default:
        throw StateError('Operador binário inválido: ${n.op}');
    }
  }

  double _power(double b, double e) {
    if (!_isInt(e)) {
      if (_exact) {
        throw const ExpressionException(ExpressionErrorCode.nonIntegerResult);
      }
      if (b < 0) {
        throw const ExpressionException(ExpressionErrorCode.invalidPower);
      }
      return _check(math.pow(b, e).toDouble());
    }
    if (e < 0) {
      if (b == 0) {
        throw const ExpressionException(ExpressionErrorCode.divisionByZero);
      }
      if (_exact && b.abs() != 1) {
        throw const ExpressionException(ExpressionErrorCode.nonIntegerResult);
      }
    }
    if (b.abs() > 1 && e > 64) {
      throw const ExpressionException(ExpressionErrorCode.overflow);
    }
    var result = math.pow(b, e).toDouble();
    if (!result.isFinite) {
      throw const ExpressionException(ExpressionErrorCode.overflow);
    }
    if (e >= 0 && _isInt(b)) result = result.roundToDouble();
    return _check(result);
  }

  double _func(FuncNode n) {
    final v = eval(n.arg);
    switch (n.op) {
      case OperatorKind.sqrt:
        if (v < 0) {
          throw const ExpressionException(ExpressionErrorCode.negativeSqrt);
        }
        final s = math.sqrt(v);
        final rs = s.roundToDouble();
        if (rs * rs == v) return rs;
        if (_exact) {
          throw const ExpressionException(ExpressionErrorCode.nonIntegerRoot);
        }
        return s;
      case OperatorKind.cbrt:
        final c = v.abs();
        final sign = v < 0 ? -1.0 : 1.0;
        final s = math.pow(c, 1 / 3).toDouble();
        final rs = s.roundToDouble();
        if (rs * rs * rs == c) return sign * rs;
        if (_exact) {
          throw const ExpressionException(ExpressionErrorCode.nonIntegerRoot);
        }
        return sign * s;
      case OperatorKind.absOpen:
        return v.abs();
      case OperatorKind.floorOpen:
        return _snap(v).floorToDouble();
      case OperatorKind.ceilOpen:
        return _snap(v).ceilToDouble();
      case OperatorKind.factorial:
        final x = _snap(v);
        if (x < 0 || !_isInt(x)) {
          throw const ExpressionException(
              ExpressionErrorCode.invalidFactorial);
        }
        var res = 1.0;
        for (var k = 2; k <= x; k++) {
          res *= k;
          if (res > _maxAbs) {
            throw const ExpressionException(ExpressionErrorCode.overflow);
          }
        }
        return res;
      default:
        throw StateError('Função inválida: ${n.op}');
    }
  }
}