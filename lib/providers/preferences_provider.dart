import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/preferences_service.dart';

/// Sobrescrito no main() com a instância real (SharedPreferences é assíncrono).
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Sobrescreva no ProviderScope (main.dart)'),
);

final preferencesServiceProvider = Provider<PreferencesService>(
  (ref) => PreferencesService(ref.watch(sharedPreferencesProvider)),
);