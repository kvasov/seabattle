import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/app/styles/media.dart';
import 'package:seabattle/features/ships_setup/presentation/viewmodels/setup_ships_viewmodel.dart';

class ShipSetupActions extends ConsumerWidget {
  const ShipSetupActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupShipsProvider = ref.watch(setupShipsViewModelProvider);
    final setupShipsNotifier = ref.watch(setupShipsViewModelProvider.notifier);
    final setupShipsState = setupShipsProvider.value;

    final iconSize = deviceType(context) == DeviceType.phone ? 24.0 : 36.0;

    return Row(
      mainAxisAlignment: .center,
      children: [
        TextButton(
          onPressed: () => setupShipsNotifier.rotateSelectedOrientation(),
          child: Icon(Icons.rotate_left_rounded, size: iconSize),
        ),
        TextButton(
          onPressed: () => setupShipsNotifier.removeLastShip(),
          child: Icon(Icons.undo, size: iconSize),
        ),
        TextButton(
          onPressed: setupShipsState != null && setupShipsNotifier.countNeedPlaceShips() > 0
              ? () => setupShipsNotifier.autoPlaceShips()
              : null,
          style: TextButton.styleFrom(
            foregroundColor: setupShipsState != null && setupShipsNotifier.countNeedPlaceShips() > 0
                ? null
                : Colors.grey.shade300,
          ),
          child: Icon(Icons.auto_awesome, size: iconSize),
        ),
        TextButton(
          onPressed: () => setupShipsNotifier.clearShips(),
          child: Icon(Icons.clear, size: iconSize),
        ),
      ]
    );
  }
}