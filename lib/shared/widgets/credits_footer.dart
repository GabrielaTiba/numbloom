import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme.dart';
import '../../l10n/generated/app_localizations.dart';

/// Faixa de madeira com os nomes dos integrantes do grupo.
class CreditsFooter extends StatelessWidget {
  const CreditsFooter({super.key, required this.members});

  final List<String> members;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final px = context.pixel;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: px.panelBorder.withValues(alpha: 0.92),
        border: Border(top: BorderSide(color: px.panelRing, width: 3)),
      ),
      child: Text(
        l.groupCredits(members.join(' • ')),
        textAlign: TextAlign.center,
        style:
            Theme.of(context).textTheme.bodyMedium?.copyWith(color: px.operatorInk),
      ),
    );
  }
}