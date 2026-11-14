import 'dart:math';

import '../models/challenge_model.dart';

/// Sorteia números de 4 dígitos que o usuário AINDA NÃO resolveu.
class ChallengeService {
  ChallengeService([Random? random]) : _random = random ?? Random();

  final Random _random;

  static const int min = 1000;
  static const int max = 9999;
  static const int total = max - min + 1;

  /// Devolve null quando todos os números já foram resolvidos.
  /// [skipped] (pulados nesta sessão) só é evitado se houver alternativa.
  ChallengeModel? pickUnsolved({
    required Set<int> solved,
    Set<int> skipped = const {},
  }) {
    if (solved.length >= total) return null;

    // Caminho rápido: sorteio direto (quase sempre acerta de primeira).
    for (var i = 0; i < 200; i++) {
      final n = min + _random.nextInt(total);
      if (!solved.contains(n) && !skipped.contains(n)) return ChallengeModel(n);
    }

    // Quase tudo resolvido: percorre os restantes.
    final unsolved = [
      for (var n = min; n <= max; n++)
        if (!solved.contains(n)) n,
    ];
    if (unsolved.isEmpty) return null;
    final fresh = unsolved.where((n) => !skipped.contains(n)).toList();
    final pool = fresh.isNotEmpty ? fresh : unsolved;
    return ChallengeModel(pool[_random.nextInt(pool.length)]);
  }
}