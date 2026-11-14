import 'package:flutter_test/flutter_test.dart';
import 'package:numbloom/core/game/operator_kind.dart';
import 'package:numbloom/models/expression_model.dart';
import 'package:numbloom/models/progress_model.dart';
import 'package:numbloom/core/game/game_level.dart';
import 'package:numbloom/models/game_session.dart';
import 'package:numbloom/services/challenge_service.dart';

void main() {
  group('ExpressionModel', () {
    test('o "=" começa no espaço 2', () {
      final e = ExpressionModel.initial();
      expect(e.gaps[2], [OperatorKind.equals]);
      expect(e.operatorCount, 0);
    });

    test('mover o "=" tira o anterior', () {
      final e = ExpressionModel.initial().place(OperatorKind.equals, 3);
      expect(e.gaps[2], isEmpty);
      expect(e.gaps[3], [OperatorKind.equals]);
    });

    test('tokens na ordem certa e barra alternando abre/fecha', () {
      final e = ExpressionModel.initial()
          .place(OperatorKind.absOpen, 0)
          .place(OperatorKind.absOpen, 2, 0); // antes do "="
      final t = e.toTokens(['2', '5', '3', '1']);
      expect(t.map((x) => x.toString()).join(), '|25|=31');
    });

    test('inserir à esquerda de uma peça já colocada', () {
      var e = ExpressionModel.initial().place(OperatorKind.power, 1);
      e = e.place(OperatorKind.subtract, 1, 0); // antes do **
      expect(e.gaps[1], [OperatorKind.subtract, OperatorKind.power]);
      e = e.place(OperatorKind.add, 1, 1); // entre os dois
      expect(e.gaps[1],
          [OperatorKind.subtract, OperatorKind.add, OperatorKind.power]);
    });

    test('mover uma peça já colocada para outro espaço e dentro do mesmo', () {
      var e = ExpressionModel.initial()
          .place(OperatorKind.add, 0)
          .place(OperatorKind.multiply, 0);
      e = e.move(0, 0, 3, 0); // + vai para o espaço 3
      expect(e.gaps[0], [OperatorKind.multiply]);
      expect(e.gaps[3], [OperatorKind.add]);
      e = ExpressionModel.initial()
          .place(OperatorKind.add, 1)
          .place(OperatorKind.subtract, 1)
          .place(OperatorKind.multiply, 1);
      e = e.move(1, 0, 1, 3); // + para o fim do mesmo espaço
      expect(e.gaps[1], [
        OperatorKind.subtract,
        OperatorKind.multiply,
        OperatorKind.add,
      ]);
    });

    test('mover o "=" por inserção na mesma posição não o duplica', () {
      final e = ExpressionModel.initial().place(OperatorKind.equals, 2, 0);
      expect(e.gaps[2], [OperatorKind.equals]);
      expect(e.hasEquals, isTrue);
    });

    test('removeLast ignora o "=" e clearOperators o mantém', () {
      var e = ExpressionModel.initial()
          .place(OperatorKind.add, 1)
          .place(OperatorKind.subtract, 3);
      e = e.removeLast();
      expect(e.gaps[3], isEmpty);
      expect(e.gaps[1], [OperatorKind.add]);
      e = e.clearOperators();
      expect(e.operatorCount, 0);
      expect(e.hasEquals, isTrue);
    });
  });

  group('ChallengeService', () {
    test('nunca devolve número já resolvido', () {
      final service = ChallengeService();
      final solved = {for (var n = 1000; n < 9900; n++) n};
      for (var i = 0; i < 50; i++) {
        final c = service.pickUnsolved(solved: solved)!;
        expect(solved.contains(c.number), isFalse);
      }
    });

    test('devolve null quando tudo foi resolvido', () {
      final solved = {for (var n = 1000; n <= 9999; n++) n};
      expect(ChallengeService().pickUnsolved(solved: solved), isNull);
    });
  });

  group('GameSession (voltar de onde parou)', () {
    test('salva e restaura número, nível e peças', () {
      final e = ExpressionModel.initial()
          .place(OperatorKind.sqrt, 0)
          .place(OperatorKind.power, 3, 0);
      final session = GameSession(
        level: GameLevel.advanced,
        number: 4821,
        gaps: e.toNames(),
      );
      final back = GameSession.decode(session.encode())!;
      expect(back.level, GameLevel.advanced);
      expect(back.number, 4821);
      final restored = ExpressionModel.fromNames(back.gaps)!;
      expect(restored.gaps[0], [OperatorKind.sqrt]);
      expect(restored.gaps[2], [OperatorKind.equals]);
      expect(restored.gaps[3], [OperatorKind.power]);
    });

    test('dados corrompidos são ignorados', () {
      expect(GameSession.decode(null), isNull);
      expect(GameSession.decode('isso não é json'), isNull);
      expect(GameSession.decode('{"level":"x","number":1,"gaps":[]}'), isNull);
      expect(ExpressionModel.fromNames([[], []]), isNull);
      expect(ExpressionModel.fromNames([['nada'], [], [], [], []]), isNull);
    });
  });

  test('ProgressModel soma pontos e conta por nível', () {
    final p = ProgressModel.empty
        .withSolution(GameLevel.easy, 1234, 10)
        .withSolution(GameLevel.hard, 1234, 60);
    expect(p.score, 70);
    expect(p.solvedCount, 2);
    expect(p.solvedAt(GameLevel.easy), {1234});
  });
}