import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/entities/game.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/features/battle/presentation/widgets/grid.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';
import 'package:seabattle/features/battle/presentation/viewmodels/battle_viewmodel.dart';
import 'package:seabattle/shared/widgets/drawer.dart';
import 'package:seabattle/shared/widgets/menu_btn.dart';
import 'package:seabattle/shared/widgets/firework.dart';
import 'package:seabattle/shared/widgets/my_error_widget.dart';
import 'package:seabattle/features/battle/presentation/widgets/arrow_rive.dart';

class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final gameNotifier = ref.watch(gameNotifierProvider);
    final gameState = gameNotifier.value;
    final battleViewModelNotifier = ref.watch(battleViewModelProvider);
    final battleViewModelState = battleViewModelNotifier.value;

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      body: _buildBody(gameNotifier, battleViewModelNotifier, gameState, battleViewModelState),
    );
  }

  Widget _buildBody(
    AsyncValue<GameState> gameNotifier,
    AsyncValue<BattleViewModelState> battleViewModelNotifier,
    GameState? gameState,
    BattleViewModelState? battleViewModelState,
  ) {
    // Проверяем состояние ошибки для обоих провайдеров
    if (gameNotifier.hasError) {
      return MyErrorWidget(
        error: 'Game Error: ${gameNotifier.error}',
        retryCallback: () async {
          await ref.read(gameNotifierProvider.notifier).updateGame(gameNotifier.value?.game?.id ?? 0, GameAction.cancel);
          final updatedState = ref.read(gameNotifierProvider);
          if (!updatedState.hasError) {
            ref.read(navigationProvider.notifier).goToHomeScreen();
          }
        },
      );
    }

    if (battleViewModelNotifier.value?.isError == true) {
      return MyErrorWidget(
        error: 'Battle Error: ${battleViewModelNotifier.value?.errorMessage ?? 'Unknown error'}',
        retryCallback: () {
          ref.read(battleViewModelProvider.notifier).sendLastShot();
        },
      );
    }

    // Проверяем состояние загрузки для обоих провайдеров
    if (gameNotifier.isLoading || battleViewModelNotifier.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Оба провайдера в состоянии data - отображаем контент
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (gameState?.isLoading == true)
              const CircularProgressIndicator(),
            if (gameState?.game?.opponentReady == false)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: const Text('Waiting for opponent to be ready'),
              )
            else ...[
              Center(
                child: BattleGrid(myShips: false),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ArrowRive(),
              ),
            ],
            Center(
              child: BattleGrid(myShips: true),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () => ref.read(gameNotifierProvider.notifier).cancelGame(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 128, 128, 128),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Cancel Game'),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => ref.read(battleViewModelProvider.notifier).showFirework(), child: const Text('Show Firework')),
            ),
          ],
        ),
        MenuBtn(scaffoldKey: _scaffoldKey),
        if (battleViewModelState?.showFirework == true) ...[
          const FireworkWidget(text: 'Поздравляем,\nтеперь вы читер'),
        ],
      ],
    );
  }
}