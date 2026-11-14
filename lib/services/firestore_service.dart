import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/game/game_level.dart';
import '../models/progress_model.dart';
import 'progress_repository.dart';

/// Persistência no Firestore (plano Spark).
///
/// Estrutura:
///   users/{uid}                      -> { score, solved: { easy: [..], ... },
///                                         updatedAt }
///   users/{uid}/solutions/{nível_número} -> histórico de soluções
/// Os números resolvidos ficam num único documento (1 leitura por carga),
/// o que poupa a cota diária gratuita de leituras.
class FirestoreProgressRepository implements ProgressRepository {
  FirestoreProgressRepository([FirebaseFirestore? db])
      : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  static const _timeout = Duration(seconds: 15);

  DocumentReference<Map<String, dynamic>> _user(String uid) =>
      _db.collection('users').doc(uid);

  @override
  Future<ProgressModel> loadProgress(String uid) async {
    final snap = await _user(uid).get().timeout(_timeout);
    return _parse(snap.data());
  }

  ProgressModel _parse(Map<String, dynamic>? data) {
    if (data == null) return ProgressModel.empty;
    final raw = data['solved'];
    final solved = <GameLevel, Set<int>>{};
    if (raw is Map) {
      for (final level in GameLevel.values) {
        final list = raw[level.name];
        if (list is List) {
          solved[level] = {
            for (final e in list)
              if (e is num) e.toInt(),
          };
        }
      }
    }
    return ProgressModel(
      score: (data['score'] as num?)?.toInt() ?? 0,
      solved: solved,
    );
  }

  @override
  Future<List<SolutionRecord>> loadRecentSolutions(String uid,
      {int limit = 10}) async {
    final snap = await _user(uid)
        .collection('solutions')
        .orderBy('solvedAt', descending: true)
        .limit(limit)
        .get()
        .timeout(_timeout);
    return [
      for (final doc in snap.docs)
        SolutionRecord(
          number: (doc.data()['number'] as num?)?.toInt() ?? 0,
          level: GameLevel.values.firstWhere(
            (l) => l.name == doc.data()['level'],
            orElse: () => GameLevel.easy,
          ),
          expression: doc.data()['expression'] as String? ?? '',
          latex: doc.data()['latex'] as String? ?? '',
          points: (doc.data()['points'] as num?)?.toInt() ?? 0,
          solvedAt: (doc.data()['solvedAt'] as Timestamp?)?.toDate(),
        ),
    ];
  }

  @override
  Future<void> saveSolution(String uid, SolutionRecord r) async {
    final userRef = _user(uid);
    final solutionRef =
        userRef.collection('solutions').doc('${r.level.name}_${r.number}');
    final batch = _db.batch();
    batch.set(
      userRef,
      {
        'score': FieldValue.increment(r.points),
        'solved': {
          r.level.name: FieldValue.arrayUnion([r.number]),
        },
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    batch.set(solutionRef, {
      'number': r.number,
      'level': r.level.name,
      'expression': r.expression,
      'latex': r.latex,
      'points': r.points,
      'solvedAt': FieldValue.serverTimestamp(),
    });
    await batch.commit().timeout(_timeout);
  }
}