import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/game/expression_evaluator.dart';
import '../../../core/game/latex_builder.dart';
import '../../../core/game/operator_kind.dart';
import '../../../core/routing/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/expression_model.dart';
import '../../../models/progress_model.dart';
import '../../../providers/game_provider.dart';
import '../../../providers/progress_provider.dart';
import '../../../providers/sound_provider.dart';
import '../../../services/sound_service.dart';
import '../../../shared/animations/tile_flight.dart';
import '../../../shared/widgets/bloom_loader.dart';
import '../../../shared/widgets/pixel_button.dart';
import '../../../shared/widgets/wood_panel.dart';
import 'expression_board.dart';
import 'feedback_panel.dart';
import 'formula_preview.dart';
import 'game_header.dart';
import 'operator_palette.dart';
import 'success_dialog.dart';

/// Tela de jogo (depois que o progresso foi carregado do Firestore).
///
/// Fluxo: escolher nível -> montar a expressão -> Verificar.
///  * ERRO: as peças FICAM onde estão (o jogador continua de onde parou), o
///    tabuleiro balança e a mensagem aparece logo abaixo do número.
///  * ACERTO: as peças voam de volta aos botões, uma janela com uma flor
///    desabrochando mostra os pontos e o resultado é gravado no Firestore.
class GameBoard extends ConsumerStatefulWidget {
  const GameBoard({super.key});

  @override
  ConsumerState<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends ConsumerState<GameBoard>
    with SingleTickerProviderStateMixin {
  bool _busy = false;
  bool _picking = false;
  SolutionRecord? _pending;

  final Map<String, GlobalKey> _tokenKeys = {};
  final Map<OperatorKind, GlobalKey> _paletteKeys = {};
  final GlobalKey _feedbackKey = GlobalKey();

  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  GlobalKey _tokenKey(int gap, int index) =>
      _tokenKeys.putIfAbsent('$gap-$index', () => GlobalKey());

  GlobalKey _paletteKey(OperatorKind op) =>
      _paletteKeys.putIfAbsent(op, () => GlobalKey());

  /// Primeira vez: retoma a partida salva (se houver) ou sorteia um número.
  void _ensureChallenge() {
    final game = ref.read(gameProvider);
    if (game.challenge != null || game.allSolved || _picking) return;
    _picking = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _picking = false;
      if (!mounted) return;
      final g = ref.read(gameProvider);
      if (g.challenge != null || g.allSolved) return;
      ref
          .read(gameProvider.notifier)
          .startSession(ref.read(progressProvider).solvedAt(g.level));
    });
  }

  Set<int> get _solved {
    final level = ref.read(gameProvider).level;
    return ref.read(progressProvider).solvedAt(level);
  }

  List<TileFlightSpec> _captureFlights(GameState game) {
    final specs = <TileFlightSpec>[];
    for (var g = 0; g < ExpressionModel.gapCount; g++) {
      for (var i = 0; i < game.expression.gaps[g].length; i++) {
        final op = game.expression.gaps[g][i];
        if (op == OperatorKind.equals) continue; // o "=" fica no lugar
        final target = op == OperatorKind.absClose ? OperatorKind.absOpen : op;
        final from = globalTopLeft(_tokenKey(g, i));
        final to = globalTopLeft(_paletteKey(target));
        if (from == null || to == null) continue;
        specs.add(TileFlightSpec(from: from, to: to, label: op.symbol));
      }
    }
    return specs;
  }

  void _scrollToFeedback() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _feedbackKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          alignment: 0.2,
        );
      }
    });
  }

  Future<void> _check() async {
    if (_busy) return;
    final game = ref.read(gameProvider);
    final challenge = game.challenge;
    if (challenge == null) return;

    final notifier = ref.read(gameProvider.notifier);
    final sound = ref.read(soundServiceProvider);
    final tokens = game.tokens;
    final result = ExpressionEvaluator.evaluate(tokens, game.level);
    final correct = result.isCorrect && !result.hasError;
    final latex = LatexBuilder.fromTokens(tokens, game.level);
    final text = tokens.map((t) => t.toString()).join();

    setState(() => _busy = true);
    notifier.setFeedback(GameFeedback(
      correct: correct,
      expressionText: text,
      latex: latex,
      errorCode: result.error?.code,
      errorToken: result.error?.token,
      left: result.leftValue,
      right: result.rightValue,
      points: correct ? game.level.points : 0,
    ));

    if (!correct) {
      // ERRO: NÃO limpa as peças. O jogador continua de onde estava.
      sound.play(SoundEffect.error);
      if (!MediaQuery.disableAnimationsOf(context)) _shake.forward(from: 0);
      _scrollToFeedback();
      if (mounted) setState(() => _busy = false);
      return;
    }

    // ACERTO: as peças voltam aos botões e aparece a comemoração.
    final specs = _captureFlights(game); // antes de limpar a expressão
    notifier.clearOperators();
    sound.play(SoundEffect.success);
    await playTileFlight(context, specs);
    if (!mounted) return;

    _pending = SolutionRecord(
      number: challenge.number,
      level: game.level,
      expression: text,
      latex: latex,
      points: game.level.points,
    );
    final saving = _save();
    _showSuccess();
    await saving;
    if (mounted) setState(() => _busy = false);
  }

  void _showSuccess() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        onNext: () => ref.read(gameProvider.notifier).newChallenge(_solved),
        onSeeGarden: () {
          ref.read(gameProvider.notifier).newChallenge(_solved);
          context.go(AppRoutes.progress);
        },
        onRetrySave: _save,
      ),
    );
  }

  Future<void> _save() async {
    final record = _pending;
    if (record == null) return;
    final notifier = ref.read(gameProvider.notifier);
    notifier.patchFeedback(saving: true, saveFailed: false);
    try {
      await ref.read(progressProvider.notifier).recordSolution(record);
      _pending = null;
      notifier.patchFeedback(saving: false);
      ref.read(soundServiceProvider).play(SoundEffect.bloom);
    } catch (_) {
      notifier.patchFeedback(saving: false, saveFailed: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final game = ref.watch(gameProvider);
    final progress = ref.watch(progressProvider);
    final notifier = ref.read(gameProvider.notifier);
    _ensureChallenge();

    final wide = MediaQuery.sizeOf(context).width >= 960;
    final solvedNow = game.feedback?.correct == true;
    final interactive = !_busy && !solvedNow;
    final challenge = game.challenge;

    final header = GameHeader(
      level: game.level,
      score: progress.score,
      enabled: !_busy,
      onLevelChanged: (v) => notifier.setLevel(v, progress.solvedAt(v)),
    );

    final Widget boardContent;
    if (game.allSolved) {
      boardContent = Text(l.gameAllSolved, textAlign: TextAlign.center);
    } else if (challenge == null) {
      boardContent = const Center(child: BloomLoader());
    } else {
      // Instrução sempre visível: muda conforme o que o jogador está fazendo.
      final String? hint = game.selected != null
          ? l.gameTapGapHint
          : (game.expression.operatorCount == 0 ? l.gameStartHint : null);
      boardContent = Column(
        children: [
          ExpressionBoard(
            digits: challenge.digits,
            expression: game.expression,
            selected: game.selected,
            enabled: interactive,
            tokenKey: _tokenKey,
            onSlotTap: notifier.placeSelected,
            onDrop: (gap, index, drag) => drag.fromBoard
                ? notifier.move(drag.fromGap!, drag.fromIndex!, gap, index)
                : notifier.place(drag.op, gap, index),
            onRemove: notifier.removeAt,
            onDragStart: notifier.select,
            onDragEnd: () => notifier.select(null),
          ),
          if (hint != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                hint,
                textAlign: TextAlign.center,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
        ],
      );
    }

    // O tabuleiro balança quando a resposta está errada.
    final board = AnimatedBuilder(
      animation: _shake,
      child: WoodPanel(title: l.gameNumberLabel, child: boardContent),
      builder: (context, child) {
        final v = _shake.value;
        final dx = math.sin(v * math.pi * 8) * 10 * (1 - v);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
    );

    final preview = FormulaPreview(
        latex: LatexBuilder.fromTokens(game.tokens, game.level));

    final palette = WoodPanel(
      title: l.gameOperators,
      child: OperatorPalette(
        level: game.level,
        selected: game.selected,
        equalsPlaced: game.expression.hasEquals,
        enabled: interactive && challenge != null,
        paletteKey: _paletteKey,
        onTap: notifier.toggleSelect,
        onDragStart: notifier.select,
        onDragEnd: () => notifier.select(null),
      ),
    );

    final canCheck = interactive && challenge != null;
    final actions = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // "Verificar" em destaque, ocupando a largura toda.
        PixelButton(
          label: l.gameCheck,
          icon: const Icon(Icons.check),
          expanded: true,
          onPressed: canCheck ? _check : null,
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 4,
          children: [
            PixelButton(
              label: l.gameUndo,
              variant: PixelButtonVariant.neutral,
              onPressed: canCheck ? notifier.removeLast : null,
            ),
            PixelButton(
              label: l.gameClear,
              variant: PixelButtonVariant.neutral,
              onPressed: canCheck ? notifier.clearOperators : null,
            ),
            PixelButton(
              label: l.gameSkip,
              variant: PixelButtonVariant.secondary,
              icon: const Icon(Icons.skip_next),
              onPressed: (!_busy && challenge != null)
                  ? () => notifier.skip(_solved)
                  : null,
            ),
          ],
        ),
      ],
    );

    // Resultado logo abaixo do número (não escondido no fim da página).
    final Widget? feedback = game.feedback == null
        ? null
        : KeyedSubtree(
            key: _feedbackKey,
            child: FeedbackPanel(
              feedback: game.feedback!,
              onNext: () => notifier.newChallenge(_solved),
              onRetrySave: _save,
            ),
          );

    const gap = SizedBox(height: 12);
    final Widget content = wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(children: [
                  header,
                  gap,
                  board,
                  gap,
                  if (feedback != null) ...[feedback, gap],
                  preview,
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(children: [palette, gap, actions]),
              ),
            ],
          )
        : Column(children: [
            header,
            gap,
            board,
            gap,
            if (feedback != null) ...[feedback, gap],
            preview,
            gap,
            palette,
            gap,
            actions,
          ]);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: content,
        ),
      ),
    );
  }
}