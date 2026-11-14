import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/progress_model.dart';
import '../../../providers/progress_provider.dart';
import '../../../shared/widgets/bloom_loader.dart';
import '../../../shared/widgets/pixel_button.dart';
import '../../../shared/widgets/wood_panel.dart';
import '../widgets/game_board.dart';

/// Tela do jogo. Lê o progresso do Firestore com FutureBuilder (e o
/// indicador de progresso personalizado) antes de mostrar o tabuleiro.
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
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
        return const GameBoard();
      },
    );
  }
}