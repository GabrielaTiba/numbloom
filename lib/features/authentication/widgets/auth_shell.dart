import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/pixel_theme.dart';
import '../../../core/theme/sprites.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/credits_footer.dart';
import '../../../shared/widgets/ground_band.dart';
import '../../../shared/widgets/mini_crate_button.dart';
import '../../../shared/widgets/pixel_sprite.dart';
import '../../../shared/widgets/sky_backdrop.dart';
import '../../../shared/widgets/wood_panel.dart';
import '../../../shared/widgets/wooden_sign.dart';
import 'connected_controls.dart';

/// Moldura das telas de entrar / cadastrar / Google: mesmo céu, placa,
/// gramado, idioma, tema e som da tela inicial. O formulário (firebase_ui_auth)
/// fica num painel de madeira. Em telas largas: placa à esquerda e formulário
/// à direita.
class AuthShell extends StatelessWidget {
  const AuthShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final px = context.pixel;

    final sign = WoodenSign(title: l.appName, subtitle: l.slogan);
    final form = WoodPanel(child: child);

    return Scaffold(
      body: SkyBackdrop(
        child: Stack(
          children: [
            const Positioned(left: 0, right: 0, bottom: 0, child: GroundBand()),
            SafeArea(
              child: LayoutBuilder(builder: (context, c) {
                final wide = c.maxWidth >= 900;

                final topBar = Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MiniCrateButton(
                        semanticLabel: l.back,
                        onTap: () => context.go(AppRoutes.title),
                        child: PixelSpriteWidget(
                          sprite: Sprites.arrowLeft.recolor({'#': px.ink}),
                          pixelSize: 3,
                          alignment: Alignment.center,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ConnectedControls(),
                        ),
                      ),
                    ],
                  ),
                );

                final Widget body = wide
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),
                              child: sign,
                            ),
                          ),
                          const SizedBox(width: 40),
                          Flexible(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 460),
                              child: form,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 560),
                              child: sign,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 480),
                              child: form,
                            ),
                          ),
                        ],
                      );

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: c.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        topBar,
                        // Placa + formulário ficam centralizados na área
                        // entre a barra do topo e o rodapé.
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: body,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: CreditsFooter(members: AppConstants.groupMembers),
                        ),
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