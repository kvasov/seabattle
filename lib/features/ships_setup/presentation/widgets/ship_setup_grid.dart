import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/ships_setup/presentation/viewmodels/setup_ships_viewmodel.dart';
import 'package:seabattle/shared/providers/ui_provider.dart';
import 'package:seabattle/utils/ship_painter.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/utils/make_field.dart';
import 'package:seabattle/shared/providers/ships_images_provider.dart';
import 'package:seabattle/utils/cursor.dart';

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
            ships: setupShipsViewModelState.ships,
            gridSize: setupShipsViewModelState.gridSize,
            cursorPosition: setupShipsViewModelState.cursorPosition,
            isCursorVisible: setupShipsViewModelState.isCursorVisible ?? false,
          )
        : null;

    ref.read(cellSizeProvider.notifier).init(context);
    final cellSize = ref.watch(cellSizeProvider);
    final gridSize = setupShipsViewModelState?.gridSize ?? 0;
    final ships = setupShipsViewModelState?.ships;
    final shipsImages = ref.watch(shipsImagesProvider);

    final cursorPosition = setupShipsViewModelState?.cursorPosition;
    bool isCursorVisible = setupShipsViewModelState?.isCursorVisible ?? false;
    debugPrint('💚! isCursorVisible: ${setupShipsViewModelState?.isCursorVisible}');

    final gridWidget = shipsImages.when(
      data: (cache) => Stack(
        children: [
          CustomPaint(
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
          if (cursorPosition != null && isCursorVisible)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: cursorPosition.x * cellSize,
              top: cursorPosition.y * cellSize,
              width: cellSize,
              height: cellSize,
              child: const CursorPainter(),
            ),
        ],
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