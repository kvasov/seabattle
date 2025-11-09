import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/entities/game.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/features/ships_setup/presentation/viewmodels/setup_ships_viewmodel.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';

class CancelGameDialog extends ConsumerWidget {
  const CancelGameDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameNotifierProvider);
    final gameId = gameState.value?.game?.id;

    return AlertDialog(
      title: const Text('Отменить игру?'),
      content: Text('Вы уверены, что хотите отменить игру #${gameId}?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Нет'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            final id = gameId;
            if (id != null) {
              ref.read(gameNotifierProvider.notifier).updateGame(id, GameAction.cancel);
              ref.read(setupShipsViewModelProvider.notifier).clearShips();
              ref.read(battleViewModelProvider.notifier).resetBattle();
            }
          },
          child: const Text('Да'),
        ),
      ],
    );
  }
}

class CanceledGameDialog extends ConsumerWidget {
  const CanceledGameDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Игра отменена соперником'),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(gameNotifierProvider.notifier).resetGame();
            ref.read(setupShipsViewModelProvider.notifier).clearShips();
            ref.read(battleViewModelProvider.notifier).resetBattle();
            ref.read(navigationProvider.notifier).pushHomeScreen();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

