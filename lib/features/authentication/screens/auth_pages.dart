import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routing/app_routes.dart';
import '../../../providers/sound_provider.dart';
import '../../../services/sound_service.dart';
import '../widgets/auth_shell.dart';

// Os formulários são do firebase_ui_auth (LoginView), mas dentro da moldura
// AuthShell, com o mesmo visual da tela inicial. Os textos deles são
// traduzidos pelo FirebaseUILocalizations (en/pt).

Widget _flow(
  WidgetRef ref,
  AuthAction action,
  List<AuthProvider> providers, {
  bool allowSwitch = false,
}) {
  void done(BuildContext context) {
    ref.read(soundServiceProvider).play(SoundEffect.bloom);
    context.go(AppRoutes.game);
  }

  return AuthShell(
    child: FirebaseUIActions(
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) => done(context)),
        AuthStateChangeAction<UserCreated>((context, state) => done(context)),
        // "Esqueci a senha": abre a nossa tela (com a moldura do app).
        ForgotPasswordAction(
          (context, email) => context.push(AppRoutes.forgotPassword, extra: email),
        ),
      ],
      child: LoginView(
        action: action,
        providers: providers,
        // Mostra "Não tem conta? Cadastre-se" / "Já tem conta? Entrar".
        showAuthActionSwitch: allowSwitch,
      ),
    ),
  );
}

/// Redefinição de senha: o Firebase envia um e-mail com o link para criar
/// uma nova senha (precisa do login por e-mail/senha ativado).
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) =>
      AuthShell(child: ForgotPasswordView(email: email));
}

class EmailSignInPage extends ConsumerWidget {
  const EmailSignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      _flow(ref, AuthAction.signIn, [EmailAuthProvider()], allowSwitch: true);
}

class GoogleSignInPage extends ConsumerWidget {
  const GoogleSignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => _flow(
        ref,
        AuthAction.signIn,
        [GoogleProvider(clientId: AppConstants.googleClientId)],
      );
}

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      _flow(ref, AuthAction.signUp, [EmailAuthProvider()], allowSwitch: true);
}