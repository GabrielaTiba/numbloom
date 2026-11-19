import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/game/expression_parser.dart';
import '../core/game/game_level.dart';
import '../core/game/operator_kind.dart';
import '../models/challenge_model.dart';
import '../models/expression_model.dart';
import '../models/game_session.dart';
import '../services/challenge_service.dart';
import 'auth_provider.dart';
import 'preferences_provider.dart';

final challengeServiceProvider = Provider<ChallengeService>((ref) => ChallengeService());

/// Resultado da última verificação.
class GameFeedback {
  const GameFeedback({
    required this.correct,
    required this.expressionText,
    required this.latex,
    this.errorCode,
    this.errorToken,
    this.left,
    this.right,
    this.points = 0,
    this.saving = false,
    this.saveFailed = false,
  });

  final bool correct;
  final String expressionText;
  final String latex;
  final ExpressionErrorCode? errorCode;
  final OperatorKind? errorToken;
  final double? left;
  final double? right;
  final int points;
  final bool saving;
  final bool saveFailed;

  GameFeedback copyWith({bool? saving, bool? saveFailed}) => GameFeedback(
        correct: correct,
        expressionText: expressionText,
        latex: latex,
        errorCode: errorCode,
        errorToken: errorToken,
        left: left,
        right: right,
        points: points,
        saving: saving ?? this.saving,
        saveFailed: saveFailed ?? this.saveFailed,
      );
}

class GameState {
  const GameState({
    required this.level,
    required this.expression,
    this.challenge,
    this.selected,
    this.skipped = const {},
    this.feedback,
    this.allSolved = false,
  });

  final GameLevel level;
  final ExpressionModel expression;
  final ChallengeModel? challenge;
  final OperatorKind? selected;
  final Set<int> skipped; // pulados nesta sessão
  final GameFeedback? feedback;
  final bool allSolved;

  List<ExprToken> get tokens =>
      challenge == null ? const [] : expression.toTokens(challenge!.digits);

  GameState copyWith({
    ExpressionModel? expression,
    OperatorKind? selected,
    bool clearSelected = false,
    GameFeedback? feedback,
    bool clearFeedback = false,
  }) =>
      GameState(
        level: level,
        expression: expression ?? this.expression,
        challenge: challenge,
        selected: clearSelected ? null : (selected ?? this.selected),
        skipped: skipped,
        feedback: clearFeedback ? null : (feedback ?? this.feedback),
        allSolved: allSolved,
      );
}

final gameProvider =
    NotifierProvider<GameNotifier, GameState>(GameNotifier.new);

class GameNotifier extends Notifier<GameState> {
  @override
  GameState build() {
    ref.watch(currentUserIdProvider); // trocar de conta reinicia o jogo
    return GameState(
      level: ref.read(preferencesServiceProvider).gameLevel,
      expression: ExpressionModel.initial(),
    );
  }

  // ---- desafios ----

  void setLevel(GameLevel level, Set<int> solved) {
    if (level == state.level && state.challenge != null) return;
    ref.read(preferencesServiceProvider).setGameLevel(level);
    state = GameState(
      level: level,
      expression: ExpressionModel.initial(),
      skipped: state.skipped,
    );
    newChallenge(solved);
  }

  /// Sorteia um número que o usuário ainda não resolveu neste nível.
  void newChallenge(Set<int> solved) {
    final picked = ref
        .read(challengeServiceProvider)
        .pickUnsolved(solved: solved, skipped: state.skipped);
    state = GameState(
      level: state.level,
      expression: ExpressionModel.initial(),
      challenge: picked,
      skipped: state.skipped,
      allSolved: picked == null,
    );
    _persist();
  }

  /// Ao abrir o jogo: retoma a partida salva (mesmo número e peças) se esse
  /// número ainda não foi resolvido; senão, sorteia um novo.
  void startSession(Set<int> solved) {
    final uid = ref.read(currentUserIdProvider);
    final saved =
        uid == null ? null : ref.read(preferencesServiceProvider).loadGameSession(uid);
    if (saved != null &&
        saved.level == state.level &&
        saved.number >= ChallengeService.min &&
        saved.number <= ChallengeService.max &&
        !solved.contains(saved.number)) {
      final expression = ExpressionModel.fromNames(saved.gaps);
      if (expression != null) {
        state = GameState(
          level: state.level,
          expression: expression,
          challenge: ChallengeModel(saved.number),
          skipped: state.skipped,
        );
        return;
      }
    }
    newChallenge(solved);
  }

  /// Guarda a partida atual (nível, número e peças colocadas).
  void _persist() {
    final uid = ref.read(currentUserIdProvider);
    final challenge = state.challenge;
    if (uid == null || challenge == null) return;
    ref.read(preferencesServiceProvider).saveGameSession(
          uid,
          GameSession(
            level: state.level,
            number: challenge.number,
            gaps: state.expression.toNames(),
          ),
        );
  }

  /// Pula o número atual (não é salvo como resolvido).
  void skip(Set<int> solved) {
    final current = state.challenge;
    state = GameState(
      level: state.level,
      expression: state.expression,
      challenge: current,
      skipped: {...state.skipped, if (current != null) current.number},
    );
    newChallenge(solved);
  }

  // ---- expressão ----

  void _setExpression(ExpressionModel e) {
    state = state.copyWith(
      expression: e,
      // Mantém a tela de "acertou" até o jogador pedir o próximo número.
      clearFeedback: state.feedback?.correct != true,
    );
    _persist();
  }

  void select(OperatorKind? op) => state = state.copyWith(
        selected: op,
        clearSelected: op == null,
      );

  void toggleSelect(OperatorKind op) => select(state.selected == op ? null : op);

  void placeSelected(int gap, [int? index]) {
    final op = state.selected;
    if (op == null) return;
    place(op, gap, index);
  }

  void place(OperatorKind op, int gap, [int? index]) {
    state = state.copyWith(clearSelected: true);
    _setExpression(state.expression.place(op, gap, index));
  }

  /// Move uma peça que já está na expressão (arrastar para outro espaço).
  void move(int fromGap, int fromIndex, int toGap, [int? toIndex]) {
    state = state.copyWith(clearSelected: true);
    _setExpression(state.expression.move(fromGap, fromIndex, toGap, toIndex));
  }

  void removeAt(int gap, int index) =>
      _setExpression(state.expression.removeAt(gap, index));

  void removeLast() => _setExpression(state.expression.removeLast());

  void clearOperators() {
    state = state.copyWith(
      expression: state.expression.clearOperators(),
      clearSelected: true,
    );
    _persist();
  }

  // ---- feedback ----

  void setFeedback(GameFeedback feedback) =>
      state = state.copyWith(feedback: feedback);

  void patchFeedback({bool? saving, bool? saveFailed}) {
    final f = state.feedback;
    if (f == null) return;
    state = state.copyWith(
      feedback: f.copyWith(saving: saving, saveFailed: saveFailed),
    );
  }
}