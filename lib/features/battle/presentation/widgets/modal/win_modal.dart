import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/shared/presentation/styles/dialogs.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class WinModal extends ConsumerWidget {
  const WinModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    return AlertDialog(
      title: Text(
        t.modals.winModalTitle,
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
