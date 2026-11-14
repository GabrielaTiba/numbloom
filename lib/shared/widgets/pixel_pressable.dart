import 'package:flutter/material.dart';

/// Gancho global chamado em TODO toque de botão/peça (o app liga isso ao
/// serviço de som; fica nulo nas demos). Mantém os widgets sem Riverpod.
class PixelTapHook {
  const PixelTapHook._();
  static VoidCallback? onTap;
}

class PixelPressState {
  const PixelPressState({
    required this.pressed,
    required this.hover,
    required this.focus,
  });
  final bool pressed;
  final bool hover;
  final bool focus;
}

/// Comportamento de interação comum (toque, mouse, teclado, semântica) para
/// botões "de jogo". O visual é definido pelo [builder].
class PixelPressable extends StatefulWidget {
  const PixelPressable({
    super.key,
    required this.builder,
    required this.semanticLabel,
    this.onTap,
    this.selected = false,
  });

  final Widget Function(BuildContext context, PixelPressState state) builder;
  final String semanticLabel;
  final VoidCallback? onTap;
  final bool selected;

  @override
  State<PixelPressable> createState() => _PixelPressableState();
}

class _PixelPressableState extends State<PixelPressable> {
  bool _pressed = false;
  bool _hover = false;
  bool _focus = false;

  void _fire() {
    PixelTapHook.onTap?.call();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      selected: widget.selected,
      label: widget.semanticLabel,
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
            onTap: enabled ? _fire : null,
            child: widget.builder(
              context,
              PixelPressState(pressed: _pressed, hover: _hover, focus: _focus),
            ),
          ),
        ),
      ),
    );
  }
}