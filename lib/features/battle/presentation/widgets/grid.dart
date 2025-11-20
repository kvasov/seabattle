import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/utils/ship_painter.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';
import 'package:seabattle/shared/providers/ships_images_provider.dart';
import 'package:seabattle/shared/providers/ble_provider.dart';
import 'package:seabattle/shared/providers/ui_provider.dart';
import 'package:seabattle/shared/providers/cheater_provider.dart';
import 'package:seabattle/utils/make_field.dart';
import 'package:seabattle/utils/cursor.dart';

class BattleGrid extends ConsumerStatefulWidget {
  const BattleGrid({
    super.key,
    required this.myShips,
    this.ships = const [],
  });

  final bool myShips;
  final List<Ship>? ships;

  @override
  ConsumerState<BattleGrid> createState() => _BattleGridState();
}

class _BattleGridState extends ConsumerState<BattleGrid> with SingleTickerProviderStateMixin {
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
    final shipsImages = ref.watch(shipsImagesProvider);
    final ships = widget.myShips
      ? ref.watch(battleViewModelProvider).value?.ships ?? []
      : ref.watch(battleViewModelProvider).value?.opponentShips ?? [];
    final battleViewModel = ref.watch(battleViewModelProvider);
    final battleViewModelState = battleViewModel.value;
    final shots = widget.myShips
      ? battleViewModelState?.opponentShots ?? []
      : battleViewModelState?.shots ?? [];
    final field = battleViewModelState != null
      ? makeField(
          ships: ships,
          gridSize: battleViewModelState.gridSize,
          shots: shots,
          isCursorVisible: true,
        )
      : null;

    ref.read(cellSizeProvider.notifier).init(context);
    final cellSize = ref.watch(cellSizeProvider);

    final gridSize = battleViewModelState?.gridSize ?? 0;
    final bleNotifier = ref.read(bleNotifierProvider);
    final bool isCursorVisible = widget.myShips
      ? false
      : bleNotifier.value?.isConnected ?? false
        ? true
        : false;
    final GridPosition? cursorPosition = battleViewModelState?.cursorPosition;

    final isCheater = ref.watch(cheaterProvider).isCheater;
    final gridWidget = shipsImages.when(
      data: (cache) => Stack(
        children: [
          CustomPaint(
              size: Size(cellSize * gridSize, cellSize * gridSize),
              painter: SeaBattlePainter(
                myShips: widget.myShips,
                ships: ships,
                battleMode: true,
                field: field ?? List.generate(
                  gridSize,
                  (_) => List.generate(gridSize, (_) => CellState.empty),
                ),
                cellSize: cellSize,
                shipsImagesCache: cache,
                waveAnimation: _waveAnimation,
                isCheaterMode: isCheater,
              ),
            ),
          if (cursorPosition != null && isCursorVisible && battleViewModelState?.myMove == true)
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
      loading: () => Center(child: CircularProgressIndicator()),
    );

    return GestureDetector(
      onTapDown: (details) {
        if (!widget.myShips) {
          ref.read(battleViewModelProvider.notifier).handleTapDown(details);
        }
      },
      child: gridWidget
    );
  }
}