import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/entities/game.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';

class CancelGameDialog extends ConsumerStatefulWidget {
  const CancelGameDialog({super.key});

  @override
  ConsumerState<CancelGameDialog> createState() => _CancelGameDialogState();
}

class _CancelGameDialogState extends ConsumerState<CancelGameDialog> {
  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameNotifierProvider);
    final gameId = gameState.value?.game?.id;

    return AlertDialog(
      title: const Text('Отменить игру?'),
      content: Text('Вы уверены, что хотите отменить игру #$gameId?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Нет'),
        ),
        TextButton(
          onPressed: () async {
            final id = gameId;
            if (id == null) {
              Navigator.of(context).pop();
              return;
            }

            // Сохраняем ссылки на провайдеры ДО закрытия диалога
            final gameNotifier = ref.read(gameNotifierProvider.notifier);
            final navigationNotifier = ref.read(navigationProvider.notifier);

            // Закрываем диалог
            Navigator.of(context).pop();

            // Ждем завершения операции отмены игры
            await gameNotifier.updateGame(id, GameAction.cancel);

            // Проверяем состояние провайдера после завершения операции
            // В StatefulWidget ref безопасен для использования даже после pop()
            if (mounted) {
              final updatedGameState = ref.read(gameNotifierProvider);
              if (!updatedGameState.hasError && updatedGameState.value?.isError != true) {
                debugPrint('🔥 cancelGameDialog: ошибки нет, переходим на homeScreen');
                navigationNotifier.goToHomeScreen();
              } else {
                debugPrint('🔥 cancelGameDialog: ошибка в gameNotifier, не переходим на homeScreen');
              }
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
            ref.read(navigationProvider.notifier).goToHomeScreen();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class AcceptedGameDialog extends ConsumerWidget {
  const AcceptedGameDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Игра уже принята кем-то другим'),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(gameNotifierProvider.notifier).resetGame();
            ref.read(navigationProvider.notifier).goToHomeScreen();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}