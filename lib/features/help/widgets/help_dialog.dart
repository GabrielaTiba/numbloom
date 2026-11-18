import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../core/game/game_level.dart';
import '../../../core/game/game_level_l10n.dart';
import '../../../core/game/latex_builder.dart';
import '../../../core/game/operator_kind.dart';
import '../../../core/theme/pixel_theme.dart';
import '../../../core/theme/sprites.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/math_tile.dart';
import '../../../shared/widgets/pixel_box.dart';
import '../../../shared/widgets/pixel_button.dart';
import '../../../shared/widgets/pixel_dialog.dart';
import '../../../shared/widgets/pixel_sprite.dart';

/// Ajuda "Como jogar" (aberta pelo botão "?" da barra de navegação):
/// objetivo com exemplo visual, passos numerados, operadores por nível,
/// regras e jardim. O conteúdo rola dentro do diálogo.
class HelpDialog extends StatelessWidget {
  const HelpDialog({super.key});

  static Future<void> show(BuildContext context) =>
      showDialog<void>(context: context, builder: (_) => const HelpDialog());

  // (rótulo exibido, operador usado para consultar o nível)
  static const List<(String, OperatorKind)> _ops = [
    ('+', OperatorKind.add),
    ('−', OperatorKind.subtract),
    ('×', OperatorKind.multiply),
    ('÷', OperatorKind.divide),
    ('( )', OperatorKind.parenOpen),
    ('√', OperatorKind.sqrt),
    ('∛', OperatorKind.cbrt),
    ('!', OperatorKind.factorial),
    ('**', OperatorKind.power),
    ('|x|', OperatorKind.absOpen),
    ('⌊x⌋', OperatorKind.floorOpen),
    ('⌈x⌉', OperatorKind.ceilOpen),
  ];

  // Exemplo do enunciado: 8131 -> √(8+1) = 3**1
  static const List<String> _digits = ['8', '1', '3', '1'];
  static const List<ExprToken> _example = [
    ExprToken.op(OperatorKind.sqrt),
    ExprToken.op(OperatorKind.parenOpen),
    ExprToken.digit('8'),
    ExprToken.op(OperatorKind.add),
    ExprToken.digit('1'),
    ExprToken.op(OperatorKind.parenClose),
    ExprToken.op(OperatorKind.equals),
    ExprToken.digit('3'),
    ExprToken.op(OperatorKind.power),
    ExprToken.digit('1'),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final px = context.pixel;
    final theme = Theme.of(context);

    final steps = [l.helpStep1, l.helpStep2, l.helpStep3, l.helpStep4, l.helpStep5];
    final rules = [
      l.helpRule1,
      l.helpRule2,
      l.helpRule3,
      l.helpRule4,
      l.helpRule5,
    ];

    return PixelDialog(
      title: l.helpTitle,
      maxWidth: 680,
      actions: [
        PixelButton(
          label: l.close,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---- Objetivo + exemplo ----
          _Section(
            icon: Sprites.flowerRed,
            title: l.helpGoalTitle,
            child: Text(l.helpGoalBody),
          ),
          _Example(
            caption: l.helpExample,
            note: l.helpExampleCaption,
            digits: _digits,
            tokens: _example,
          ),
          const SizedBox(height: 20),

          // ---- Passo a passo ----
          _Section(
            icon: Sprites.sprout,
            title: l.helpHowTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StepBadge(number: i + 1),
                        const SizedBox(width: 12),
                        Expanded(child: Text(steps[i])),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ---- Níveis ----
          _Section(
            icon: Sprites.mushroom,
            title: l.helpLevelsTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final level in GameLevel.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 12,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(level.label(l),
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(color: px.ink)),
                            Text(l.helpLevelPoints(level.points),
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: px.action)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 2,
                          children: [
                            for (final (label, kind) in _ops)
                              if (level.allows(kind))
                                MathTile(label: label, size: 38),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // ---- Regras ----
          _Section(
            icon: Sprites.bush,
            title: l.helpRulesTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final rule in rules)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Container(width: 8, height: 8, color: px.action),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(rule)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // ---- Jardim ----
          _Section(
            icon: Sprites.tree,
            title: l.helpGardenTitle,
            child: Text(l.helpGardenBody),
          ),
        ],
      ),
    );
  }
}

/// Título com ícone em pixel art + conteúdo.
class _Section extends StatelessWidget {
  const _Section({required this.icon, required this.title, required this.child});

  final PixelSprite icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PixelSpriteWidget(sprite: icon, size: 32, alignment: Alignment.center),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: px.action),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

/// Exemplo visual: dígitos -> peças -> fórmula em LaTeX.
class _Example extends StatelessWidget {
  const _Example({
    required this.caption,
    required this.note,
    required this.digits,
    required this.tokens,
  });

  final String caption;
  final String note;
  final List<String> digits;
  final List<ExprToken> tokens;

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    final theme = Theme.of(context);
    final latex = LatexBuilder.fromTokens(tokens, GameLevel.easy);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: CustomPaint(
        painter: PixelBoxPainter(
          fill: px.tileFace.withValues(alpha: 0.55),
          border: px.panelRing,
          pixel: 2,
          notch: 3,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Text(caption,
                  style: theme.textTheme.titleMedium?.copyWith(color: px.ink)),
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                children: [
                  for (final d in digits)
                    MathTile(label: d, kind: TileKind.digit, size: 40),
                ],
              ),
              Icon(Icons.arrow_downward, color: px.action),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                children: [
                  for (final t in tokens)
                    MathTile(
                      label: t.isDigit ? t.digit! : t.op!.symbol,
                      kind: t.isDigit ? TileKind.digit : TileKind.operator,
                      size: 40,
                    ),
                ],
              ),
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Math.tex(
                  latex,
                  textStyle: TextStyle(fontSize: 24, color: px.ink),
                  onErrorFallback: (_) => Text(latex),
                ),
              ),
              const SizedBox(height: 4),
              Text(note,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(color: px.ink)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quadradinho numerado dos passos.
class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    return SizedBox(
      width: 30,
      height: 30,
      child: CustomPaint(
        painter: PixelBoxPainter(
          fill: px.action,
          border: px.panelBorder,
          pixel: 2,
          notch: 3,
        ),
        child: Center(
          child: Text(
            '$number',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: px.actionInk),
          ),
        ),
      ),
    );
  }
}