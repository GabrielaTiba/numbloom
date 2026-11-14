import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/sprites.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/credits_footer.dart';
import '../../../shared/widgets/crate_button.dart';
import '../../../shared/widgets/ground_band.dart';
import '../../../shared/widgets/pixel_sprite.dart';
import '../../../shared/widgets/sky_backdrop.dart';
import '../../../shared/widgets/wooden_sign.dart';

/// Tela inicial (parte visual). Sem Firebase nem Riverpod: os botões chamam
/// callbacks e os controles do topo (idioma, tema, som) vêm de [controls].
class TitleScreen extends StatefulWidget {
  const TitleScreen({
    super.key,
    required this.controls,
    required this.members,
    required this.onSignIn,
    required this.onSignUp,
    required this.onGoogle,
  });

  final Widget controls;
  final List<String> members;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;
  final VoidCallback onGoogle;

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1500));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      if (MediaQuery.disableAnimationsOf(context)) {
        _intro.value = 1;
      } else {
        _intro.forward();
      }
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: SkyBackdrop(
        child: Stack(
          children: [
            const Positioned(left: 0, right: 0, bottom: 0, child: GroundBand()),
            SafeArea(
              child: LayoutBuilder(builder: (context, c) {
                final w = c.maxWidth;
                final compact = w < 520;
                final crateW =
                    compact ? ((w - 32 - 14) / 2).clamp(120.0, 170.0) : 168.0;
                final crateH = crateW * 0.84;

                final controls = Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: widget.controls,
                  ),
                );

                final sign = AnimatedBuilder(
                  animation: _intro,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: WoodenSign(title: l.appName, subtitle: l.slogan),
                    ),
                  ),
                  builder: (context, child) {
                    final t = const Interval(0, 0.6).transform(_intro.value);
                    final v = Curves.bounceOut.transform(t);
                    return Opacity(
                      opacity: math.min(1.0, t * 3),
                      child: Transform.translate(
                          offset: Offset(0, -(1 - v) * 240), child: child),
                    );
                  },
                );

                final crates = AnimatedBuilder(
                  animation: _intro,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 14,
                      runSpacing: 10,
                      children: [
                        CrateButton(
                          label: l.titleSignIn,
                          width: crateW,
                          height: crateH,
                          icon: const PixelSpriteWidget(
                              sprite: Sprites.sprout,
                              size: 44,
                              alignment: Alignment.center),
                          onPressed: widget.onSignIn,
                        ),
                        CrateButton(
                          label: l.titleSignUp,
                          width: crateW,
                          height: crateH,
                          icon: PixelSpriteWidget(
                              sprite: Sprites.flowerPink,
                              size: 44,
                              alignment: Alignment.center),
                          onPressed: widget.onSignUp,
                        ),
                        CrateButton(
                          label: l.titleGoogle,
                          width: crateW,
                          height: crateH,
                          icon: const PixelSpriteWidget(
                              sprite: Sprites.googleG,
                              size: 40,
                              alignment: Alignment.center),
                          onPressed: widget.onGoogle,
                        ),
                      ],
                    ),
                  ),
                  builder: (context, child) {
                    final t = const Interval(0.45, 1.0).transform(_intro.value);
                    final v = Curves.easeOutBack.transform(t);
                    return Opacity(
                      opacity: math.max(0.0, math.min(1.0, v)),
                      child: Transform.translate(
                          offset: Offset(0, (1 - v) * 60), child: child),
                    );
                  },
                );

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: c.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        controls,
                        // Placa e caixotes formam UM bloco, centralizado
                        // entre os controles do topo e o rodapé.
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [sign, const SizedBox(height: 20), crates],
                          ),
                        ),
                        CreditsFooter(members: widget.members),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}