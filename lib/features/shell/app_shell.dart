import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/pixel_theme.dart';
import '../../core/theme/sprites.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/preferences_provider.dart';
import '../../shared/widgets/grass_backdrop.dart';
import '../../shared/widgets/pixel_box.dart';
import '../../shared/widgets/pixel_sprite.dart';
import '../help/widgets/help_dialog.dart';
import 'widgets/shell_top_bar.dart';

/// Casca das páginas logadas: fundo de gramado + barra curva SEMPRE visível
/// (Jogar, Progresso, Configurações e Ajuda), cada aba com o NOME escrito
/// embaixo do ícone. Ajuda abre um diálogo.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final _navKey = GlobalKey<CurvedNavigationBarState>();

  static const _helpIndex = 3;

  @override
  void initState() {
    super.initState();
    // Quem usa o app pela primeira vez vê o "Como jogar" sem precisar procurar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final prefs = ref.read(preferencesServiceProvider);
      if (!prefs.helpSeen) {
        prefs.setHelpSeen();
        HelpDialog.show(context);
      }
    });
  }

  Future<void> _onTap(int i) async {
    final current = widget.navigationShell.currentIndex;
    if (i == _helpIndex) {
      await HelpDialog.show(context);
      // Ajuda não é uma página: a barra volta para a aba atual.
      _navKey.currentState?.setPage(current);
    } else {
      widget.navigationShell.goBranch(i, initialLocation: i == current);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final px = context.pixel;
    final index = widget.navigationShell.currentIndex;
    final labels = [l.navGame, l.navProgress, l.navSettings, l.navHelp];

    // Lembra a última aba para restaurar ao reabrir o app.
    ref.read(preferencesServiceProvider).setLastRoute(AppRoutes.tabPaths[index]);

    return Scaffold(
      body: GrassBackdrop(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const ShellTopBar(),
              Expanded(child: widget.navigationShell),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          CurvedNavigationBar(
            key: _navKey,
            index: index,
            height: 72,
            color: px.panelRing,
            buttonBackgroundColor: px.reward,
            backgroundColor: Colors.transparent,
            animationDuration: const Duration(milliseconds: 300),
            onTap: _onTap,
            items: [
              _NavIcon(label: labels[0], sprite: Sprites.sprout),
              _NavIcon(label: labels[1], sprite: Sprites.flowerRed),
              _NavIcon(
                  label: labels[2],
                  sprite: Sprites.gear.recolor({'#': px.ink})),
              _NavIcon(
                  label: labels[3],
                  sprite: Sprites.question.recolor({'#': px.ink})),
            ],
          ),
          // Nomes das abas, sempre visíveis (a ativa em destaque).
          Positioned(
            left: 0,
            right: 0,
            bottom: 6,
            child: IgnorePointer(
              child: _NavLabels(labels: labels, selected: index),
            ),
          ),
        ],
      ),
    );
  }
}

/// Uma coluna de texto por aba, alinhada com os ícones da barra.
class _NavLabels extends StatelessWidget {
  const _NavLabels({required this.labels, required this.selected});

  final List<String> labels;
  final int selected;

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    final style = Theme.of(context).textTheme.bodySmall;
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  labels[i],
                  maxLines: 1,
                  style: style?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: i == selected ? px.reward : px.operatorInk,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Ícone da barra: sprite sobre uma plaquinha de pergaminho (boa leitura
/// tanto sobre a madeira quanto sobre o círculo amarelo da aba ativa).
class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.label, required this.sprite});

  final String label;
  final PixelSprite sprite;

  @override
  Widget build(BuildContext context) {
    final px = context.pixel;
    return Semantics(
      label: label,
      button: true,
      child: ExcludeSemantics(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CustomPaint(
            painter: PixelBoxPainter(
              fill: px.panelFill,
              border: px.panelBorder,
              pixel: 2,
              notch: 3,
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: PixelSpriteWidget(
                sprite: sprite,
                size: 28,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}