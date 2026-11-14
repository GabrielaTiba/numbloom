import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

/// Usuário autenticado (null = deslogado). Gerenciado pelo Firebase Auth.
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

/// Uid do usuário logado (null = deslogado). Recalculado a cada mudança de
/// login, o que "zera" os providers de jogo e progresso ao trocar de conta.
final currentUserIdProvider = Provider<String?>((ref) {
  ref.watch(authStateProvider);
  return FirebaseAuth.instance.currentUser?.uid;
});

final authServiceProvider = Provider<AuthService>((ref) => const AuthService());