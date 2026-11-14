import 'package:flutter/material.dart';

import 'wood_panel.dart';

/// Diálogo com visual de painel de madeira. Use com `showDialog`.
class PixelDialog extends StatelessWidget {
  const PixelDialog({
    super.key,
    required this.title,
    required this.child,
    this.actions = const [],
    this.maxWidth = 560,
  });

  final String title;
  final Widget child;
  final List<Widget> actions;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: WoodPanel(
          title: title,
          fillChild: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(child: SingleChildScrollView(child: child)),
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 4,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}