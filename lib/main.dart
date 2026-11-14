import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'l10n/generated/app_localizations.dart';
import 'providers/preferences_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // Espera o Firebase restaurar a sessão (evita piscar a tela de login).
    await FirebaseAuth.instance
        .authStateChanges()
        .first
        .timeout(const Duration(seconds: 15));
  } catch (_) {
    // Configuração ausente/errada ou sem internet: mostra um aviso claro em
    // vez de uma tela em branco.
    runApp(const _FirebaseErrorApp());
    return;
  }
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const NumBloomApp(),
    ),
  );
}

class _FirebaseErrorApp extends StatelessWidget {
  const _FirebaseErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                AppLocalizations.of(context)!.firebaseInitError,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}