import 'package:flutter_test/flutter_test.dart';
import 'package:numbloom/core/game/game_level.dart';
import 'package:numbloom/core/game/operator_kind.dart';
import 'package:numbloom/core/game/expression_evaluator.dart';
import 'package:numbloom/core/game/expression_parser.dart';
import 'package:numbloom/core/game/latex_builder.dart';

/// Atalho de teste: dígitos viram tokens de dígito; símbolos:
/// + - * / ( ) √ ∛ ! ^(potência) = ; A/a = |..| ; F/f = ⌊⌋ ; C/c = ⌈⌉
List<ExprToken> tok(String s) {
  const map = {
    '+': OperatorKind.add,
    '-': OperatorKind.subtract,
    '*': OperatorKind.multiply,
    '/': OperatorKind.divide,
    '(': OperatorKind.parenOpen,
    ')': OperatorKind.parenClose,
    '√': OperatorKind.sqrt,
    '∛': OperatorKind.cbrt,
    '!': OperatorKind.factorial,
    '^': OperatorKind.power,
    'A': OperatorKind.absOpen,
    'a': OperatorKind.absClose,
    'F': OperatorKind.floorOpen,
    'f': OperatorKind.floorClose,
    'C': OperatorKind.ceilOpen,
    'c': OperatorKind.ceilClose,
    '=': OperatorKind.equals,
  };
  return [
    for (final ch in s.split(''))
      if (RegExp(r'\d').hasMatch(ch))
        ExprToken.digit(ch)
      else
        ExprToken.op(map[ch]!)
  ];
}

EvaluationResult run(String s, GameLevel l) =>
    ExpressionEvaluator.evaluate(tok(s), l);

void main() {
  test('exemplo do enunciado: √(8+1)=3**1', () {
    expect(run('√(8+1)=3^1', GameLevel.easy).isCorrect, isTrue);
    expect(LatexBuilder.fromTokens(tok('√(8+1)=3^1'), GameLevel.easy),
        r'\sqrt{8 + 1} = 3^{1}');
  });

  test('exemplo da animação: (5-2)! = 6*1', () {
    expect(run('(5-2)!=6*1', GameLevel.intermediate).isCorrect, isTrue);
  });

  test('precedência e concatenação de dígitos', () {
    expect(run('2+3*4=14', GameLevel.hard).isCorrect, isTrue);
    expect(run('2+3*4=20', GameLevel.hard).isCorrect, isFalse);
  });

  test('menos unário e potência', () {
    expect(run('-2^2=-4', GameLevel.intermediate).isCorrect, isTrue);
    expect(run('2^3^2=512', GameLevel.intermediate).isCorrect, isTrue);
  });

  test('divisão não inteira só no nível fácil', () {
    expect(run('5/2*2=5', GameLevel.easy).isCorrect, isTrue);
    expect(run('5/2*2=5', GameLevel.intermediate).error?.code,
        ExpressionErrorCode.nonIntegerDivision);
  });

  test('operadores indisponíveis por nível', () {
    expect(run('(5-2)!=6*1', GameLevel.hard).error?.code,
        ExpressionErrorCode.operatorNotAllowed);
    expect(run('∛27=3', GameLevel.advanced).error?.code,
        ExpressionErrorCode.operatorNotAllowed);
    expect(run('F5/2f=2', GameLevel.intermediate).error?.code,
        ExpressionErrorCode.operatorNotAllowed);
  });

  test('piso, teto, módulo', () {
    expect(run('F5/2f=2', GameLevel.easy).isCorrect, isTrue);
    expect(run('C5/2c=3', GameLevel.easy).isCorrect, isTrue);
    expect(run('A2-5a=3', GameLevel.hard).isCorrect, isTrue);
  });

  test('raízes', () {
    expect(run('∛27=3', GameLevel.easy).isCorrect, isTrue);
    expect(run('√2=2', GameLevel.intermediate).error?.code,
        ExpressionErrorCode.nonIntegerRoot);
    expect(run('√2*√2=2', GameLevel.easy).isCorrect, isTrue);
    expect(run('√(0-4)=2', GameLevel.easy).error?.code,
        ExpressionErrorCode.negativeSqrt);
  });

  test('erros de domínio', () {
    expect(run('1/0=1', GameLevel.easy).error?.code,
        ExpressionErrorCode.divisionByZero);
    expect(run('20!=1', GameLevel.intermediate).error?.code,
        ExpressionErrorCode.overflow);
    expect(run('(0-3)!=1', GameLevel.intermediate).error?.code,
        ExpressionErrorCode.invalidFactorial);
  });

  test('erros de sintaxe', () {
    expect(run('12', GameLevel.easy).error?.code,
        ExpressionErrorCode.missingEquals);
    expect(run('1=2=3', GameLevel.easy).error?.code,
        ExpressionErrorCode.multipleEquals);
    expect(run('(1+2=3', GameLevel.easy).error?.code,
        ExpressionErrorCode.unbalanced);
    expect(run('1+=2', GameLevel.easy).error?.code,
        ExpressionErrorCode.unexpectedEnd);
    expect(run('1*/2=2', GameLevel.easy).error?.code,
        ExpressionErrorCode.unexpectedToken);
    expect(run('1+2=', GameLevel.easy).error?.code,
        ExpressionErrorCode.unexpectedEnd);
    expect(run('2(3)=6', GameLevel.easy).error?.code,
        ExpressionErrorCode.unexpectedToken);
  });

  test('precedência igual à do enunciado do professor', () {
    bool ok(String s) => run(s, GameLevel.easy).isCorrect;
    expect(ok('1+2*3=7'), isTrue); // 1 + (2*3)
    expect(ok('2*3!=12'), isTrue); // 2 * (3!)
    expect(ok('√16!=24'), isTrue); // (√16)! = 4! = 24  (e NÃO √(16!))
    // (√8)! não é inteiro => erro de fatorial (prova que o ! vale para a raiz)
    expect(run('√8!+0=1+1', GameLevel.easy).error?.code,
        ExpressionErrorCode.invalidFactorial);
    expect(ok('-2+2=0+0'), isTrue); // (-2) + 2
    expect(ok('--2+0!=3+0'), isTrue); // (-(-2)) + 0!
    expect(ok('-(-2+5)=4-7'), isTrue);
    expect(ok('∛-8=-2'), isTrue); // raiz cúbica de número negativo
    expect(ok('√√(8*2)=2'), isTrue); // raízes aninhadas
  });

  test('expressões compostas: vários menos unários e fatoriais duplos', () {
    // ---(1+2)=-3 : três menos unários
    expect(run('---(1+2)=-3', GameLevel.easy).isCorrect, isTrue);
    // 3!! = (3!)! = 720
    expect(run('3!!=720', GameLevel.easy).isCorrect, isTrue);
  });

  test('LaTeX: (√8)! com parênteses', () {
    expect(LatexBuilder.fromTokens(tok('√8!=1'), GameLevel.easy),
        r'\left(\sqrt{8}\right)! = 1');
  });

  test('LaTeX estruturado mesmo com a fórmula incompleta (sem "=")', () {
    expect(LatexBuilder.fromTokens(tok('∛944^4'), GameLevel.easy),
        r'\sqrt[3]{944}^{4}');
    expect(LatexBuilder.fromTokens(tok('√(8+1)='), GameLevel.easy),
        r'\sqrt{8 + 1} =');
    expect(LatexBuilder.fromTokens(tok('√(8+1)=3^'), GameLevel.easy),
        r'\sqrt{8 + 1} = 3 \mathbin{\ast\ast} ');
  });

  test('LaTeX tolerante para expressões incompletas', () {
    final s = LatexBuilder.fromTokens(tok('(8+1'), GameLevel.easy);
    expect(s, contains('('));
    expect(LatexBuilder.fromTokens(const [], GameLevel.easy), '');
  });
}