import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/utils/ship_painter.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';
import 'package:seabattle/shared/providers/ships_images_provider.dart';
import 'package:seabattle/utils/make_field.dart';

class BattleGrid extends ConsumerWidget {
  const BattleGrid({
    super.key,
    required this.myShips,
    this.ships = const [],
  });

  final bool myShips;
  final List<Ship>? ships;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shipsImages = ref.watch(shipsImagesProvider);
    final ships = myShips
      ? ref.watch(battleViewModelProvider).value?.ships ?? []
      : ref.watch(battleViewModelProvider).value?.opponentShips ?? [];
    final battleViewModel = ref.watch(battleViewModelProvider);
    final battleViewModelState = battleViewModel.value;
    final shots = myShips
      ? battleViewModelState?.opponentShots ?? []
      : battleViewModelState?.shots ?? [];
    final field = battleViewModelState != null
      ? makeField(ships, battleViewModelState.gridSize, shots)
      : null;
    final cellSize = battleViewModelState?.cellSize ?? 0;
    final gridSize = battleViewModelState?.gridSize ?? 0;

    return GestureDetector(
      onTapDown: (details) {
        if (!myShips) {
          ref.read(battleViewModelProvider.notifier).handleTapDown(details);
        }
      },
      child:
      shipsImages.when(
        data: (cache) => CustomPaint(
          size: Size(cellSize * gridSize, cellSize * gridSize),
          painter: SeaBattlePainter(
            myShips: myShips,
            ships: ships,
            battleMode: true,
            field: field ?? List.generate(
              gridSize,
              (_) => List.generate(gridSize, (_) => CellState.empty),
            ),
            cellSize: cellSize,
            shipsImagesCache: cache,
          ),
        ),
        error: (error, stack) => Center(child: Text(error.toString())),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}