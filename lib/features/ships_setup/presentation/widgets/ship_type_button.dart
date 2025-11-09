import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/ships_setup/presentation/viewmodels/setup_ships_viewmodel.dart';

class ShipTypeButton extends ConsumerWidget {
  const ShipTypeButton({super.key, required this.shipSize});

  final int shipSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed:
          () => ref.read(setupShipsViewModelProvider.notifier).setSelectedShipSize(shipSize),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              ref.watch(setupShipsViewModelProvider).value?.selectedShipSize == shipSize ? Colors.blue : null,
        ),
        child: Text('$shipSize-палуб: ${ref.watch(setupShipsViewModelProvider).value?.shipsToPlace[shipSize]}'),
      ),
    );
  }
}