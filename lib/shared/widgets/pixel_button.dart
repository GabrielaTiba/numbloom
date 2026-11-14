import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme.dart';
import '../../core/utils/color_utils.dart';
import 'pixel_box.dart';
import 'pixel_pressable.dart';

enum PixelButtonVariant { primary, secondary, neutral }

/// Botão com cara de jogo: afunda ao ser pressionado, reage a mouse
/// (hover), teclado (foco, Enter/Espaço) e toque. `onPressed == null`
/// desabilita.
class PixelButton extends StatefulWidget {
  const PixelButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = PixelButtonVariant.primary,
    this.expanded = false,
    this.minHeight = 48,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final PixelButtonVariant variant;
  final bool expanded;
  final double minHeight;

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _pressed = false;
  bool _hover = false;
  bool _focus = false;

  void _fire() {
    final cb = widget.onPressed;
    if (cb == null) return;
    PixelTapHook.onTap?.call();
    cb();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final px = context.pixel;
    final enabled = widget.onPressed != null;

    Color face;
    Color ink;
    switch (widget.variant) {
      case PixelButtonVariant.primary:
        face = px.action;
        ink = px.actionInk;
      case PixelButtonVariant.secondary:
        face = scheme.primary;
        ink = scheme.onPrimary;
      case PixelButtonVariant.neutral:
        face = px.operatorFace;
        ink = px.operatorInk;
    }
    if (!enabled) {
      face = Color.alphaBlend(
          scheme.onSurface.withValues(alpha: 0.12), scheme.surface);
      ink = scheme.onSurface.withValues(alpha: 0.38);
    } else if (_hover) {
      face = face.lighten(0.05);
    }

    final down = _pressed && enabled ? 3.0 : 0.0;
    final border = _focus ? px.reward : px.panelBorder;

    final content = ConstrainedBox(
      constraints: BoxConstraints(minHeight: widget.minHeight, minWidth: 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              IconTheme.merge(
                  data: IconThemeData(color: ink, size: 20), child: widget.icon!),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(color: ink),
              ),
            ),
          ],
        ),
      ),
    );

    Widget button = Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          enabled: enabled,
          mouseCursor:
              enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onShowHoverHighlight: (v) => setState(() => _hover = v),
          onShowFocusHighlight: (v) => setState(() => _focus = v),
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
              _fire();
              return null;
            }),
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            onTap: widget.onPressed == null ? null : _fire,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                transform: Matrix4.translationValues(0, down, 0),
                child: CustomPaint(
                  painter: PixelBoxPainter(
                    fill: face,
                    border: border,
                    pixel: 3,
                    notch: 3,
                    shadowColor: face.darken(0.2),
                    shadowOffset: enabled ? 4 - down : 0,
                    highlight: enabled ? face.lighten(0.15) : null,
                  ),
                  child: content,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.expanded) {
      button = SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}