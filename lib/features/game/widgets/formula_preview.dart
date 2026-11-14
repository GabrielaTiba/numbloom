import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../core/theme/pixel_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/wood_panel.dart';

/// Fórmula em LaTeX renderizada logo abaixo da expressão (requisito).
class FormulaPreview extends StatelessWidget {
  const FormulaPreview({super.key, required this.latex});

  final String latex;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final px = context.pixel;
    return WoodPanel(
      title: l.gameFormulaTitle,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Center(
          child: latex.isEmpty
              ? Text(l.gameFormulaEmpty, textAlign: TextAlign.center)
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Math.tex(
                    latex,
                    textStyle: TextStyle(fontSize: 28, color: px.ink),
                    onErrorFallback: (_) => Text(latex),
                  ),
                ),
        ),
      ),
    );
  }
}