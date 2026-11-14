class AppRoutes {
  const AppRoutes._();

  // Antes do login
  static const title = '/';
  static const signIn = '/sign-in';
  static const signInGoogle = '/sign-in-google';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  // Depois do login (abas com a barra de navegação)
  static const game = '/game';
  static const progress = '/progress';
  static const settings = '/settings';

  static const authRoutes = {
    title,
    signIn,
    signInGoogle,
    register,
    forgotPassword,
  };

  /// Ordem das abas na barra (o índice 3, Ajuda, abre um diálogo).
  static const tabPaths = [game, progress, settings];
}