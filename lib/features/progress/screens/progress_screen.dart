import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/progress_model.dart';
import '../../../providers/progress_provider.dart';
import '../../../shared/widgets/bloom_loader.dart';
import '../../../shared/widgets/pixel_button.dart';
import '../../../shared/widgets/wood_panel.dart';
import '../widgets/garden_view.dart';
import '../widgets/recent_solutions.dart';
import '../widgets/stats_panel.dart';

/// Progresso: pontuação, estatísticas, jardim que cresce e histórico.
class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  late Future<ProgressModel> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(progressProvider.notifier).ensureLoaded();
  }

  void _retry() => setState(
      () => _future = ref.read(progressProvider.notifier).ensureLoaded());

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return FutureBuilder<ProgressModel>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: BloomLoader(label: l.loading));
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: WoodPanel(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l.loadError, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      PixelButton(label: l.retry, onPressed: _retry),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return _Content(progress: ref.watch(progressProvider));
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.progress});

  final ProgressModel progress;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final wide = MediaQuery.sizeOf(context).width >= 960;

    final stats = StatsPanel(progress: progress);
    final garden = WoodPanel(
      title: l.progressGardenTitle,
      child: GardenView(
        solvedCount: progress.solvedCount,
        semanticLabel: l.progressGardenLabel(progress.solvedCount),
      ),
    );
    final recent = RecentSolutions(solvedCount: progress.solvedCount);

    const gap = SizedBox(height: 12);
    final Widget content = wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(children: [stats, gap, recent])),
              const SizedBox(width: 16),
              Expanded(child: garden),
            ],
          )
        : Column(children: [stats, gap, garden, gap, recent]);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: content,
        ),
      ),
    );
  }
}