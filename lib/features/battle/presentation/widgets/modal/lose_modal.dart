import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/shared/presentation/styles/dialogs.dart';

class LoseModal extends ConsumerWidget {
  const LoseModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(
        'Вы проиграли :(',
        style: dialogTitleStyle(context),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(gameNotifierProvider.notifier).resetGame();
            ref.read(navigationProvider.notifier).goToHomeScreen();
          },
          child: Text(
            'OK',
            style: dialogButtonStyle(context),
          ),
        ),
      ],
    );
  }
}
