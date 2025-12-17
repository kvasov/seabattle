import 'package:flutter/material.dart';
import 'package:seabattle/features/ships_setup/presentation/widgets/ship_type_button.dart';

class ShipSelectRow extends StatelessWidget {
  const ShipSelectRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        for (final s in [4, 3, 2, 1])
          ShipTypeButton(shipSize: s),
      ],
    );
  }
}