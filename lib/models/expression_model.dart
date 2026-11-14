import '../core/game/operator_kind.dart';

/// Operadores colocados nos 5 "espaços" ao redor dos 4 dígitos:
///   [0] d1 [1] d2 [2] d3 [3] d4 [4]
/// Imutável: cada operação devolve um novo modelo. O "=" já começa no
/// espaço 2 (ab = cd) e pode ser movido.
class ExpressionModel {
  ExpressionModel._(List<List<OperatorKind>> source)
      : gaps = List.unmodifiable(
            source.map((g) => List<OperatorKind>.unmodifiable(g)));

  factory ExpressionModel.initial() => ExpressionModel._([
        for (var i = 0; i < gapCount; i++)
          i == defaultEqualsGap ? [OperatorKind.equals] : <OperatorKind>[],
      ]);

  static const int gapCount = 5;
  static const int defaultEqualsGap = 2;
  static const int maxOperators = 24;

  final List<List<OperatorKind>> gaps;

  /// Nomes dos operadores por espaço (para salvar a partida).
  List<List<String>> toNames() => [
        for (final g in gaps) [for (final o in g) o.name],
      ];

  /// Reconstrói a partir de [toNames]; null se os dados forem inválidos.
  static ExpressionModel? fromNames(List<List<String>> names) {
    if (names.length != gapCount) return null;
    final parsed = <List<OperatorKind>>[];
    var equalsCount = 0;
    for (final row in names) {
      final ops = <OperatorKind>[];
      for (final n in row) {
        final match = OperatorKind.values.where((o) => o.name == n);
        if (match.isEmpty) return null;
        if (match.first == OperatorKind.equals) equalsCount++;
        ops.add(match.first);
      }
      parsed.add(ops);
    }
    if (equalsCount > 1) return null;
    return ExpressionModel._(parsed);
  }

  bool get hasEquals => gaps.any((g) => g.contains(OperatorKind.equals));

  /// Quantidade de operadores colocados (sem contar o "=").
  int get operatorCount => gaps.fold(
      0, (s, g) => s + g.where((o) => o != OperatorKind.equals).length);

  List<List<OperatorKind>> _copy() => [for (final g in gaps) [...g]];

  /// Coloca [op] no fim do espaço [gap]. O "=" é único: ao colocá-lo, o
  /// anterior sai do lugar antigo (ou seja, ele é movido).
  ///
  /// [index] é a posição DENTRO do espaço (0 = antes da 1ª peça desse
  /// espaço); nulo = no fim. Assim dá para inserir à esquerda ou à direita
  /// de qualquer peça já colocada.
  ExpressionModel place(OperatorKind op, int gap, [int? index]) {
    if (gap < 0 || gap >= gapCount) return this;
    if (op != OperatorKind.equals && operatorCount >= maxOperators) return this;
    final next = _copy();
    var at = index ?? next[gap].length;
    if (op == OperatorKind.equals) {
      for (var g = 0; g < next.length; g++) {
        final i = next[g].indexOf(OperatorKind.equals);
        if (i >= 0) {
          next[g].removeAt(i);
          if (g == gap && i < at) at--;
        }
      }
    }
    if (at < 0) at = 0;
    if (at > next[gap].length) at = next[gap].length;
    next[gap].insert(at, op);
    return ExpressionModel._(next);
  }

  /// Move uma peça já colocada para outra posição (arrastar e soltar).
  ExpressionModel move(int fromGap, int fromIndex, int toGap, [int? toIndex]) {
    if (fromGap < 0 || fromGap >= gapCount) return this;
    if (toGap < 0 || toGap >= gapCount) return this;
    if (fromIndex < 0 || fromIndex >= gaps[fromGap].length) return this;
    final next = _copy();
    final op = next[fromGap].removeAt(fromIndex);
    var at = toIndex ?? next[toGap].length;
    if (fromGap == toGap && fromIndex < at) at--;
    if (at < 0) at = 0;
    if (at > next[toGap].length) at = next[toGap].length;
    next[toGap].insert(at, op);
    return ExpressionModel._(next);
  }

  ExpressionModel removeAt(int gap, int index) {
    if (gap < 0 || gap >= gapCount) return this;
    if (index < 0 || index >= gaps[gap].length) return this;
    final next = _copy();
    next[gap].removeAt(index);
    return ExpressionModel._(next);
  }

  /// Remove todos os operadores, menos o "=" (que fica onde está).
  ExpressionModel clearOperators() => ExpressionModel._([
        for (final g in gaps) [for (final o in g) if (o == OperatorKind.equals) o],
      ]);

  /// Remove o último operador na ordem de leitura (nunca o "=").
  ExpressionModel removeLast() {
    for (var g = gapCount - 1; g >= 0; g--) {
      for (var i = gaps[g].length - 1; i >= 0; i--) {
        if (gaps[g][i] != OperatorKind.equals) return removeAt(g, i);
      }
    }
    return this;
  }

  /// Sequência de peças para o parser. A barra "|" é uma só no jogo: a 1ª é
  /// abertura, a 2ª fechamento, e assim por diante (módulo sem aninhamento).
  List<ExprToken> toTokens(List<String> digits) {
    final out = <ExprToken>[];
    var barOpen = false;
    for (var g = 0; g < gapCount; g++) {
      for (final op in gaps[g]) {
        if (op == OperatorKind.absOpen || op == OperatorKind.absClose) {
          out.add(ExprToken.op(
              barOpen ? OperatorKind.absClose : OperatorKind.absOpen));
          barOpen = !barOpen;
        } else {
          out.add(ExprToken.op(op));
        }
      }
      if (g < digits.length) out.add(ExprToken.digit(digits[g]));
    }
    return out;
  }
}