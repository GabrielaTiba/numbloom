import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/game/game_level_l10n.dart';
import '../../../core/theme/pixel_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/progress_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/progress_provider.dart';
import '../../../shared/widgets/bloom_loader.dart';
import '../../../shared/widgets/wood_panel.dart';

/// Últimas soluções (Firestore, com FutureBuilder). Recarrega quando o
/// jogador resolve mais um número.
class RecentSolutions extends ConsumerStatefulWidget {
  const RecentSolutions({super.key, required this.solvedCount});

  final int solvedCount;

  @override
  ConsumerState<RecentSolutions> createState() => _RecentSolutionsState();
}

class _RecentSolutionsState extends ConsumerState<RecentSolutions> {
  late Future<List<SolutionRecord>> _future = _load();

  Future<List<SolutionRecord>> _load() {
    final uid = ref.read(currentUserIdProvider);
    if (uid == null) return Future.value(const []);
    return ref.read(progressRepositoryProvider).loadRecentSolutions(uid);
  }

  @override
  void didUpdateWidget(RecentSolutions old) {
    super.didUpdateWidget(old);
    if (old.solvedCount != widget.solvedCount) _future = _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final px = context.pixel;
    final locale = Localizations.localeOf(context).toString();

    return WoodPanel(
      title: l.progressRecent,
      child: FutureBuilder<List<SolutionRecord>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: BloomLoader(size: 36, label: l.loading));
          }
          if (snap.hasError) return Text(l.loadError);
          final items = snap.data ?? const <SolutionRecord>[];
          if (items.isEmpty) return Text(l.progressNoSolutions);
          return Column(
            children: [
              for (final r in items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 56,
                        child: Text('${r.number}',
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Math.tex(
                            r.latex,
                            textStyle: TextStyle(fontSize: 18, color: px.ink),
                            onErrorFallback: (_) => Text(r.expression),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(l.gameCorrectPoints(r.points),
                              style: TextStyle(color: px.action)),
                          Text(
                            r.solvedAt == null
                                ? r.level.label(l)
                                : '${r.level.label(l)} · ${DateFormat.yMd(locale).format(r.solvedAt!)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}