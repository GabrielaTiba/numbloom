import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Localizations;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/screens/auth_pages.dart';
import '../../features/authentication/screens/title_page.dart';
import '../../providers/auth_provider.dart';
import '../../providers/preferences_provider.dart';
import 'app_routes.dart';
import 'shell_route.dart';

/// Roteamento com go_router.
///  * Deslogado: só acessa as rotas de login.
///  * Logado: abas dentro do shell (barra curva sempre visível).
///  * Ao reabrir, volta para a última aba (SharedPreferences).
final routerProvider = Provider<GoRouter>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  final refresh = ValueNotifier<int>(0);
  ref.listen<AsyncValue<User?>>(authStateProvider, (_, __) => refresh.value++);
  ref.onDispose(refresh.dispose);

  String homeLocation() {
    final last = prefs.lastRoute;
    return (last != null && AppRoutes.tabPaths.contains(last))
        ? last
        : AppRoutes.game;
  }

  final router = GoRouter(
    initialLocation: FirebaseAuth.instance.currentUser == null
        ? AppRoutes.title
        : homeLocation(),
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggedIn = FirebaseAuth.instance.currentUser != null;
      final isAuthRoute = AppRoutes.authRoutes.contains(state.matchedLocation);
      if (!loggedIn && !isAuthRoute) return AppRoutes.title;
      if (loggedIn && isAuthRoute) return homeLocation();
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.title, builder: (_, __) => const TitlePage()),
      GoRoute(
          path: AppRoutes.signIn, builder: (_, __) => const EmailSignInPage()),
      GoRoute(
          path: AppRoutes.signInGoogle,
          builder: (_, __) => const GoogleSignInPage()),
      GoRoute(
          path: AppRoutes.register, builder: (_, __) => const RegisterPage()),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) {
          // O e-mail de redefinição sai no idioma do app.
          FirebaseAuth.instance
              .setLanguageCode(Localizations.localeOf(context).languageCode);
          final extra = state.extra;
          return ForgotPasswordPage(email: extra is String ? extra : null);
        },
      ),
      buildShellRoute(),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});