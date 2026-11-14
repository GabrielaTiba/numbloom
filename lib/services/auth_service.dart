import 'package:firebase_auth/firebase_auth.dart';

/// Operações de conta. Fica atrás de um provider para que a prévia visual
/// (sem Firebase) possa trocá-lo por uma versão falsa.
class AuthService {
  const AuthService();

  Future<void> signOut() => FirebaseAuth.instance.signOut();
}