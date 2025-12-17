import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/features/ships_setup/presentation/viewmodels/setup_ships_viewmodel.dart';
import 'package:seabattle/features/ships_setup/presentation/styles/buttons.dart';

class GameActions extends ConsumerWidget {
  const GameActions({
    super.key,
    required this.buttonActionStart,
    required this.setButtonActionStart,
  });

  final bool buttonActionStart;
  final Function(bool) setButtonActionStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    final gameNotifier = ref.watch(gameNotifierProvider.notifier);
    final setupShipsNotifier = ref.watch(setupShipsViewModelProvider.notifier);
    ref.watch(setupShipsViewModelProvider);

    final needPlaceShips = setupShipsNotifier.countNeedPlaceShips();

    return Padding(
      padding: const .symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: .center,
        children: [
          ElevatedButton(
            onPressed: needPlaceShips > 0
                ? null
                : () {
                    setButtonActionStart(true);
                    gameNotifier.startGame();
                  },
            style: startGameButtonStyle(context),
            child: Text(t.setupships.buttons.startGame),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setButtonActionStart(false);
              gameNotifier.cancelGame();
            },
            style: cancelGameButtonStyle(context),
            child: Text(
              t.setupships.buttons.cancelGame,
              style: cancelGameButtonTextStyle(context)
            ),
          ),
        ],
      ),
    );
  }
}