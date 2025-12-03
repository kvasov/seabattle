import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/ships_setup/presentation/viewmodels/setup_ships_viewmodel.dart';
import 'package:seabattle/features/ships_setup/presentation/styles/buttons.dart';

class ShipTypeButton extends ConsumerWidget {
  const ShipTypeButton({super.key, required this.shipSize});

  final int shipSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupShipsProvider = ref.watch(setupShipsViewModelProvider);
    final setupShipsNotifier = ref.read(setupShipsViewModelProvider.notifier);
    final setupShipsState = setupShipsProvider.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed:
          () => setupShipsNotifier.setSelectedShipSize(shipSize),
        style: shipTypeButtonStyle(context, selected: setupShipsState?.selectedShipSize == shipSize),
        child: Text(
          'x$shipSize: ${setupShipsState?.shipsToPlace[shipSize] ?? 0}',
          style: shipTypeButtonTextStyle(context),
        ),
      ),
    );
  }
}
