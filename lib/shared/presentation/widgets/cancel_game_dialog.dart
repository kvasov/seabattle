import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/app/styles/media.dart';
import 'package:seabattle/shared/entities/game.dart';
import 'package:seabattle/shared/presentation/styles/dialogs.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class CancelGameDialog extends ConsumerStatefulWidget {
  const CancelGameDialog({super.key});

  @override
  ConsumerState<CancelGameDialog> createState() => _CancelGameDialogState();
}

class _CancelGameDialogState extends ConsumerState<CancelGameDialog> {
  @override
  Widget build(BuildContext context) {
    final t = context.t;

    final gameState = ref.watch(gameNotifierProvider);
    final gameId = gameState.value?.game?.id;

    return AlertDialog(
      title: Text(
        t.modals.cancelGameModalTitle,
        style: dialogTitleStyle(context),
      ),
      content: Text(
        t.modals.cancelGameModalContent(gameId: gameId.toString()),
        style: dialogContentStyle(context),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            t.modals.cancelGameModalButtonNo,
            style: dialogButtonStyle(context),
          ),
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

            // final updatedGameState = ref.read(gameNotifierProvider);
            navigationNotifier.goToHomeScreen();
          },
          child: Text(
            t.modals.cancelGameModalButtonYes,
            style: dialogButtonStyle(context),
          ),
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
      title: Text(
        t.modals.canceledGameModalTitle,
        style: dialogTitleStyle(context),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(gameNotifierProvider.notifier).resetGame();
            ref.read(navigationProvider.notifier).goToHomeScreen();
          },
          child: Text(
            t.modals.modalButtonOk,
            style: dialogButtonStyle(context),
          ),
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
      title: Text(
        t.modals.acceptedGameModalTitle,
        style: dialogTitleStyle(context),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(gameNotifierProvider.notifier).resetGame();
            ref.read(navigationProvider.notifier).goToHomeScreen();
          },
          child: Text(
            t.modals.modalButtonOk,
            style: dialogButtonStyle(context),
          ),
        ),
      ],
    );
  }
}


class WebSocketClosedDialog extends ConsumerWidget {
  const WebSocketClosedDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    return AlertDialog(
      constraints: BoxConstraints(maxWidth: deviceType(context) == DeviceType.phone ? 300 : 400),
      title: Text(
        t.modals.webSocketClosedModalTitle,
        style: dialogTitleStyle(context),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(gameNotifierProvider.notifier).resetGame();
            ref.read(navigationProvider.notifier).goToHomeScreen();
          },
          child: Text(
            t.modals.modalButtonOk,
            style: dialogButtonStyle(context),
          ),
        ),
      ],
    );
  }
}
