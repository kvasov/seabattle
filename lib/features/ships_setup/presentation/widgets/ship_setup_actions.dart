import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/ships_setup/presentation/viewmodels/setup_ships_viewmodel.dart';

class ShipSetupActions extends ConsumerWidget {
  const ShipSetupActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupShipsProvider = ref.watch(setupShipsViewModelProvider);
    final setupShipsNotifier = ref.watch(setupShipsViewModelProvider.notifier);
    final setupShipsState = setupShipsProvider.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.rotate_90_degrees_ccw),
          tooltip: 'Повернуть',
          onPressed:
              () => setupShipsNotifier.rotateSelectedOrientation(),
        ),
        IconButton(
          icon: const Icon(Icons.undo),
          tooltip: 'Удалить последний',
          onPressed: () => setupShipsNotifier.removeLastShip(),
        ),
        IconButton(
          disabledColor: Colors.grey.shade300,
          icon: const Icon(Icons.auto_awesome),
          tooltip: 'А',
          onPressed: setupShipsState != null &&
                    setupShipsNotifier.countNeedPlaceShips() > 0
              ? () => setupShipsNotifier.autoPlaceShips()
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: 'Очистить',
          onPressed: () => setupShipsNotifier.clearShips(),
        ),
        Text(setupShipsNotifier.countNeedPlaceShips().toString()),
      ]
    );
  }
}