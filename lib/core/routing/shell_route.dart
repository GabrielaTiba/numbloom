import 'package:go_router/go_router.dart';

import '../../features/game/screens/game_screen.dart';
import '../../features/progress/screens/progress_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/shell/app_shell.dart';
import 'app_routes.dart';

/// As abas do app (Jogar, Progresso, Configurações) dentro da barra curva.
/// Usada pelo router real e pela prévia visual.
StatefulShellRoute buildShellRoute() {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, shell) => AppShell(navigationShell: shell),
    branches: [
      StatefulShellBranch(routes: [
        GoRoute(path: AppRoutes.game, builder: (_, __) => const GameScreen()),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
            path: AppRoutes.progress,
            builder: (_, __) => const ProgressScreen()),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
            path: AppRoutes.settings,
            builder: (_, __) => const SettingsScreen()),
      ]),
    ],
  );
}