import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/core/constants/ships.dart';
import 'package:seabattle/utils/ship_placement_utils.dart';
import 'package:seabattle/features/ships_setup/presentation/styles/buttons.dart';
import 'package:seabattle/features/ships_setup/presentation/styles/texts.dart';

class IsolateWidget extends StatefulWidget {
  const IsolateWidget({super.key});

  @override
  State<IsolateWidget> createState() => _IsolateWidgetState();
}

class _IsolateWidgetState extends State<IsolateWidget> {
  int successfulIterations = 0;
  double totalSeconds = 0;
  bool done = false;
  bool calculating = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [
        Text(
          '500 000 автоматических размещений кораблей выполняется за:',
          textAlign: .center,
          style: isolateDescriptionTextStyle(context),
        ),
        if (calculating)
          Padding(
            padding: const .all(16.0),
            child: CircularProgressIndicator(),
          ),
        if (done && !calculating)
          Text(
            '${totalSeconds.toStringAsFixed(3)} секунд',
            textAlign: .center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: .bold,
              color: Colors.green
            ),
          ),
        ElevatedButton(
          style: isolateButtonStyle(context),
          onPressed: calculating ? null : () async {
            setState(() {
              calculating = true;
            });
            try {
              final result = await compute(_runAutoPlaceShipsBenchmark, 500000);
              setState(() {
                successfulIterations = result.$1;
                totalSeconds = result.$2;
                done = true;
                calculating = false;
              });
            } catch (e) {
              setState(() {
                calculating = false;
              });
            }
          },
          child: Text('Посчитать ${done ? 'ещё раз' : ''}')
        )
      ],
    );
  }
}

(int successfulIterations, double totalSeconds) _runAutoPlaceShipsBenchmark(int iterations) {
  int successfulIterations = 0;
  final random = Random();
  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < iterations; i++) {
    List<Ship> ships = [];
    Map<int, int> shipsToPlace = {...shipsToPlaceDefault};
    const int gridSize = 10;
    bool allShipsPlaced = true;

    for (final size in [4, 3, 2, 1]) {
      for (int ship = 0; ship < shipsToPlace[size]!; ship++) {
        bool shipWasPlaced = false;

        while (!shipWasPlaced) {
          int x = random.nextInt(gridSize);
          int y = random.nextInt(gridSize);
          ShipOrientation orientation = random.nextBool()
              ? ShipOrientation.horizontal
              : ShipOrientation.vertical;

          if (canPlaceShipPure(x, y, size, orientation, ships, gridSize)) {
            ships.add(Ship(x, y, size, orientation));
            shipsToPlace[size] = shipsToPlace[size]! - 1;
            shipWasPlaced = true;
          }
        }
      }
    }

    if (allShipsPlaced) {
      successfulIterations++;
    }
  }
  stopwatch.stop();
  final totalSeconds = stopwatch.elapsedMilliseconds / 1000.0;

  return (successfulIterations, totalSeconds);
}