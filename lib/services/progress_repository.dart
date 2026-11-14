import '../models/progress_model.dart';

/// Acesso aos dados do jogador. A implementação real usa o Firestore
/// (firestore_service.dart); a prévia visual usa a versão em memória.
abstract class ProgressRepository {
  Future<ProgressModel> loadProgress(String uid);

  Future<List<SolutionRecord>> loadRecentSolutions(String uid, {int limit = 10});

  Future<void> saveSolution(String uid, SolutionRecord record);
}

/// Versão em memória (só para a prévia sem Firebase).
class InMemoryProgressRepository implements ProgressRepository {
  final Map<String, ProgressModel> _progress = {};
  final Map<String, List<SolutionRecord>> _solutions = {};

  Future<void> _latency() => Future<void>.delayed(const Duration(milliseconds: 600));

  @override
  Future<ProgressModel> loadProgress(String uid) async {
    await _latency();
    return _progress[uid] ?? ProgressModel.empty;
  }

  @override
  Future<List<SolutionRecord>> loadRecentSolutions(String uid,
      {int limit = 10}) async {
    await _latency();
    return (_solutions[uid] ?? const <SolutionRecord>[]).take(limit).toList();
  }

  @override
  Future<void> saveSolution(String uid, SolutionRecord record) async {
    await _latency();
    final current = _progress[uid] ?? ProgressModel.empty;
    _progress[uid] =
        current.withSolution(record.level, record.number, record.points);
    final list = _solutions.putIfAbsent(uid, () => []);
    list.insert(
      0,
      SolutionRecord(
        number: record.number,
        level: record.level,
        expression: record.expression,
        latex: record.latex,
        points: record.points,
        solvedAt: DateTime.now(),
      ),
    );
  }
}