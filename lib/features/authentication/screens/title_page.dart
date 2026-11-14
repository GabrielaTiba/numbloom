import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routing/app_routes.dart';
import '../widgets/connected_controls.dart';
import 'title_screen.dart';

/// Rota "/": liga a TitleScreen (visual) às rotas. Idioma, tema e som vêm
/// do ConnectedControls (Riverpod).
class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TitleScreen(
      controls: const ConnectedControls(),
      members: AppConstants.groupMembers,
      onSignIn: () => context.push(AppRoutes.signIn),
      onSignUp: () => context.push(AppRoutes.register),
      onGoogle: () => context.push(AppRoutes.signInGoogle),
    );
  }
}