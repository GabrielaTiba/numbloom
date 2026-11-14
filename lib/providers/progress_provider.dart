import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/progress_model.dart';
import '../services/firestore_service.dart';
import '../services/progress_repository.dart';
import 'auth_provider.dart';

/// Repositório de dados (Firestore). A prévia visual sobrescreve este provider.
final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => FirestoreProgressRepository(),
);

/// Progresso do usuário logado (cache compartilhado entre Jogo e Progresso).
final progressProvider =
    NotifierProvider<ProgressNotifier, ProgressModel>(ProgressNotifier.new);

class ProgressNotifier extends Notifier<ProgressModel> {
  Future<ProgressModel>? _loading;

  @override
  ProgressModel build() {
    // Trocar de conta recria o provider (zera o cache).
    ref.watch(currentUserIdProvider);
    _loading = null;
    return ProgressModel.empty;
  }

  String get _uid {
    final uid = ref.read(currentUserIdProvider);
    if (uid == null) throw StateError('Nenhum usuário logado');
    return uid;
  }

  /// Carrega do Firestore uma única vez (as telas usam este Future no
  /// FutureBuilder). Em caso de erro, permite tentar de novo.
  Future<ProgressModel> ensureLoaded() => _loading ??= _load();

  Future<ProgressModel> _load() async {
    try {
      final progress =
          await ref.read(progressRepositoryProvider).loadProgress(_uid);
      state = progress;
      return progress;
    } catch (_) {
      _loading = null;
      rethrow;
    }
  }

  /// Grava a solução no Firestore e atualiza o cache local.
  Future<void> recordSolution(SolutionRecord record) async {
    await ref.read(progressRepositoryProvider).saveSolution(_uid, record);
    state = state.withSolution(record.level, record.number, record.points);
  }
}