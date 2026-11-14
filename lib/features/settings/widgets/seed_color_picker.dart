import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/pixel_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/pixel_box.dart';
import '../../../shared/widgets/pixel_pressable.dart';

/// Cores semente: predefinidas + cor personalizada (matiz).
class SeedColorPicker extends StatelessWidget {
  const SeedColorPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Color selected;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final px = context.pixel;
    final hue = HSVColor.fromColor(selected).hue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 4,
          children: [
            for (final c in NumBloomColors.seedPresets)
              PixelPressable(
                semanticLabel: l.settingsSeedColor,
                selected: c == selected,
                onTap: () => onChanged(c),
                builder: (context, s) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: CustomPaint(
                      painter: PixelBoxPainter(
                        fill: c,
                        border: (c == selected || s.focus)
                            ? px.reward
                            : px.panelBorder,
                        pixel: c == selected ? 4 : 3,
                        notch: 3,
                        shadowColor: px.shadow,
                        shadowOffset: 3,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(l.settingsCustomColor),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: hue,
                min: 0,
                max: 360,
                label: hue.round().toString(),
                onChanged: (v) => onChanged(
                    HSVColor.fromAHSV(1, v, 0.55, 0.65).toColor()),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: selected,
                border: Border.all(color: px.panelBorder, width: 3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}