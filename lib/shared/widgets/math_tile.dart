import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/pixel_theme.dart';
import '../../core/utils/color_utils.dart';
import 'pixel_box.dart';
import 'pixel_pressable.dart';

enum TileKind { digit, operator }

/// Peça independente (dígito ou operador). Estados: selecionada (sobe e
/// ganha cor de recompensa), desabilitada e "fantasma" (o espaço vazio que
/// fica na paleta quando a peça está na expressão).
class MathTile extends StatefulWidget {
  const MathTile({
    super.key,
    required this.label,
    this.kind = TileKind.operator,
    this.selected = false,
    this.ghost = false,
    this.size = 52,
    this.onTap,
    this.semanticLabel,
  });

  final String label;
  final TileKind kind;
  final bool selected;
  final bool ghost;
  final double size;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  State<MathTile> createState() => _MathTileState();
}

class _MathTileState extends State<MathTile> {
  bool _hover = false;
  bool _focus = false;
  bool _pressed = false;

  void _fire() {
    PixelTapHook.onTap?.call();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    final enabled = widget.onTap != null && !widget.ghost;
    final isDigit = widget.kind == TileKind.digit;

    Color face = isDigit ? px.tileFace : px.operatorFace;
    Color ink = isDigit ? px.ink : px.operatorInk;
    if (widget.selected) {
      face = px.reward;
      ink = const Color(0xFF2E2418);
    } else if (_hover && enabled) {
      face = face.lighten(0.06);
    }

    final dy = widget.selected ? -4.0 : (_pressed ? 2.0 : 0.0);
    final scale = widget.selected ? 1.08 : 1.0;

    final painter = widget.ghost
        ? PixelBoxPainter(
            fill: px.panelFill.withValues(alpha: 0.25),
            border: px.panelBorder.withValues(alpha: 0.35),
            pixel: 2,
            notch: 3,
          )
        : PixelBoxPainter(
            fill: face,
            border: _focus ? px.reward : px.panelBorder,
            pixel: 3,
            notch: 3,
            shadowColor: px.shadow,
            shadowOffset: widget.selected ? 6 : 3,
            highlight: face.lighten(0.14),
          );

    final label = widget.ghost
        ? const SizedBox.shrink()
        : FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                widget.label,
                style: GoogleFonts.getFont(
                  AppTheme.mathFont,
                  fontWeight: FontWeight.w700,
                  fontSize: widget.size * 0.46,
                  color: ink,
                ),
              ),
            ),
          );

    return Semantics(
      button: enabled,
      selected: widget.selected,
      label: widget.semanticLabel ?? widget.label,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          enabled: enabled,
          mouseCursor:
              enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onShowHoverHighlight: (v) => setState(() => _hover = v),
          onShowFocusHighlight: (v) => setState(() => _focus = v),
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
              if (enabled) _fire();
              return null;
            }),
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            onTap: enabled ? _fire : null,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                curve: Curves.easeOutBack,
                transformAlignment: Alignment.center,
                transform: Matrix4.translationValues(0, dy, 0) *
                    Matrix4.diagonal3Values(scale, scale, 1),
                width: widget.size,
                height: widget.size,
                child: CustomPaint(painter: painter, child: Center(child: label)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}