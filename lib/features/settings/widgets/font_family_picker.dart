import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';

/// Escolha da fonte de texto (cada opção é exibida na própria fonte).
class FontFamilyPicker extends StatelessWidget {
  const FontFamilyPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final f in AppTheme.bodyFonts)
          ChoiceChip(
            label: Text(f, style: GoogleFonts.getFont(f)),
            selected: f == selected,
            onSelected: (_) => onChanged(f),
          ),
      ],
    );
  }
}