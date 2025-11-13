import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/ships_setup/presentation/viewmodels/setup_ships_viewmodel.dart';
import 'package:seabattle/utils/ship_painter.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/utils/make_field.dart';
import 'package:seabattle/shared/providers/ships_images_provider.dart';

class ShipSetupGrid extends ConsumerStatefulWidget {
  const ShipSetupGrid({super.key});

  @override
  ConsumerState<ShipSetupGrid> createState() => _ShipSetupGridState();
}

class _ShipSetupGridState extends ConsumerState<ShipSetupGrid> with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;
  late final Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _waveAnimation = CurvedAnimation(
      parent: _waveController,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setupShipsViewModel = ref.watch(setupShipsViewModelProvider);
    final setupShipsViewModelState = setupShipsViewModel.value;
    final field = setupShipsViewModelState != null
        ? makeField(
            setupShipsViewModelState.ships,
            setupShipsViewModelState.gridSize,
          )
        : null;
    final cellSize = setupShipsViewModelState?.cellSize ?? 0;
    final gridSize = setupShipsViewModelState?.gridSize ?? 0;
    final ships = setupShipsViewModelState?.ships;
    final shipsImages = ref.watch(shipsImagesProvider);

    final gridWidget = shipsImages.when(
      data: (cache) => CustomPaint(
        size: Size(cellSize * gridSize, cellSize * gridSize),
        painter: SeaBattlePainter(
          field: field ??
              List.generate(
                gridSize,
                (_) => List.generate(gridSize, (_) => CellState.empty),
              ),
          cellSize: cellSize,
          shipsImagesCache: cache,
          ships: ships,
          waveAnimation: _waveAnimation,
        ),
      ),
      error: (error, stack) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );

    return GestureDetector(
      onTapDown: (details) => ref.read(setupShipsViewModelProvider.notifier).handleTapDown(details),
      child: gridWidget,
    );
  }
}