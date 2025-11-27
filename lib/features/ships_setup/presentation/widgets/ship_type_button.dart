import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/ships_setup/presentation/viewmodels/setup_ships_viewmodel.dart';

class ShipTypeButton extends ConsumerWidget {
  const ShipTypeButton({super.key, required this.shipSize});

  final int shipSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupShipsProvider = ref.read(setupShipsViewModelProvider);
    final setupShipsNotifier = ref.read(setupShipsViewModelProvider.notifier);
    final setupShipsState = setupShipsProvider.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed:
          () => setupShipsNotifier.setSelectedShipSize(shipSize),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          textStyle: TextStyle(fontSize: 12),
          backgroundColor:
              setupShipsState?.selectedShipSize == shipSize
                ? Colors.blue
                : null,
        ),
        child: Text('$shipSize-п:\n ${setupShipsState?.shipsToPlace[shipSize]}'),
      ),
    );
  }
}