import 'package:seabattle/core/constants/ships.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/utils/make_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class SetupShipsViewModelState {
  final List<Ship> ships;
  final Map<int, int> shipsToPlace;
  final ShipOrientation selectedOrientation;
  final int selectedShipSize;
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final int gridSize;
  final double cellSize;

  SetupShipsViewModelState({
    required this.ships,
    required this.shipsToPlace,
    required this.selectedOrientation,
    required this.selectedShipSize,
    required this.isLoading,
    required this.isError,
    required this.errorMessage,
    required this.gridSize,
    required this.cellSize,
  });

  SetupShipsViewModelState copyWith({
    List<Ship>? ships,
    Map<int, int>? shipsToPlace,
    ShipOrientation? selectedOrientation,
    int? selectedShipSize,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    int? gridSize,
    double? cellSize,
  }) {
    return SetupShipsViewModelState(
      ships: ships ?? this.ships,
      shipsToPlace: shipsToPlace ?? this.shipsToPlace,
      selectedOrientation: selectedOrientation ?? this.selectedOrientation,
      selectedShipSize: selectedShipSize ?? this.selectedShipSize,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      gridSize: gridSize ?? this.gridSize,
      cellSize: cellSize ?? this.cellSize,
    );
  }
}

class SetupShipsViewModelNotifier extends AsyncNotifier<SetupShipsViewModelState> {
  @override
  Future<SetupShipsViewModelState> build() async {
    return SetupShipsViewModelState(
      ships: [],
      shipsToPlace: shipsToPlaceDefault,
      selectedOrientation: ShipOrientation.horizontal,
      selectedShipSize: 4,
      gridSize: 10,
      cellSize: 32,
      isLoading: false,
      isError: false,
      errorMessage: '',
    );
  }

  // List<List<CellState>> get field {
  //   // Генерируем поле с учетом кораблей и запретных зон
  //   final f = List.generate(
  //     state.value!.gridSize,
  //     (_) => List.generate(state.value!.gridSize, (_) => CellState.empty),
  //   );
  //   for (final ship in state.value!.ships) {
  //     // Сначала отмечаем клетки корабля
  //     final shipCells = <Offset>[];
  //     for (int i = 0; i < ship.size; i++) {
  //       int x =
  //           ship.x + (ship.orientation == ShipOrientation.horizontal ? i : 0);
  //       int y = ship.y + (ship.orientation == ShipOrientation.vertical ? i : 0);
  //       f[y][x] = CellState.ship;
  //       shipCells.add(Offset(x.toDouble(), y.toDouble()));
  //     }
  //     // Теперь отмечаем запретные зоны только вокруг каждой палубы
  //     for (final cell in shipCells) {
  //       for (int dx = -1; dx <= 1; dx++) {
  //         for (int dy = -1; dy <= 1; dy++) {
  //           int nx = cell.dx.toInt() + dx;
  //           int ny = cell.dy.toInt() + dy;
  //           if (nx >= 0 && nx < state.value!.gridSize && ny >= 0 && ny < state.value!.gridSize) {
  //             if (f[ny][nx] == CellState.empty) {
  //               f[ny][nx] = CellState.forbidden;
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  //   return f;
  // }

  bool canPlaceShip(int x, int y, int size, ShipOrientation orientation) {
    final field = makeField(state.value!.ships, state.value!.gridSize);
    // Для каждой палубы
    for (int i = 0; i < size; i++) {
      int nx = x + (orientation == ShipOrientation.horizontal ? i : 0);
      int ny = y + (orientation == ShipOrientation.vertical ? i : 0);
      // Если координаты выходят за границы поля, то корабль нельзя разместить
      if (nx < 0 || nx >= state.value!.gridSize || ny < 0 || ny >= state.value!.gridSize) return false;
      // Если клетка не пустая, то корабль нельзя разместить
      if (field[ny][nx] != CellState.empty) return false;
    }

    // Проверяем ореол только вокруг каждой палубы
    // Для каждой палубы
    for (int i = 0; i < size; i++) {
      int cx = x + (orientation == ShipOrientation.horizontal ? i : 0);
      int cy = y + (orientation == ShipOrientation.vertical ? i : 0);
      // Для каждой клетки в ореоле
      for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
          int nx = cx + dx;
          int ny = cy + dy;
          // Если координаты в границах поля
          if (nx >= 0 && nx < state.value!.gridSize && ny >= 0 && ny < state.value!.gridSize) {
            // Если клетка занята другим кораблем, то корабль нельзя разместить
            if (field[ny][nx] == CellState.ship) return false;
          }
        }
      }
    }

    return true;
  }

  void handleTapDown(TapDownDetails details) {
    final localPosition = details.localPosition;
    debugPrint('⌖ localPosition: $localPosition');
    final x = (localPosition.dx ~/ state.value!.cellSize).clamp(0, state.value!.gridSize - 1);
    final y = (localPosition.dy ~/ state.value!.cellSize).clamp(0, state.value!.gridSize - 1);
    debugPrint('⌖ x: $x, y: $y');
    // Получаем глобальные координаты относительно экрана
    final globalPosition = details.globalPosition;
    debugPrint('⌖ globalPosition: $globalPosition');

    // Проверяем, можно ли поставить корабль
    if (state.value!.shipsToPlace[state.value!.selectedShipSize]! > 0 &&
        canPlaceShip(x, y, state.value!.selectedShipSize, state.value!.selectedOrientation)) {

      Map<int, int> newShipsToPlace = {...state.value!.shipsToPlace, state.value!.selectedShipSize: state.value!.shipsToPlace[state.value!.selectedShipSize]! - 1};

      int? newSelectedShipSize;
      for (final s in [4, 3, 2, 1]) {
        if (newShipsToPlace[s]! > 0) {
          newSelectedShipSize = s;
          break;
        }
      }

      final newState = state.value!.copyWith(
        ships: [...state.value!.ships, Ship(x, y, state.value!.selectedShipSize, state.value!.selectedOrientation)],
        shipsToPlace: newShipsToPlace,
        selectedShipSize: newSelectedShipSize,
      );

      debugPrint('⌖ shipsToPlace: $newShipsToPlace');

      state = AsyncValue.data(newState);
    }
  }

  void setSelectedShipSize(int size) {
    final newState = state.value!.copyWith(
      selectedShipSize: size,
    );
    state = AsyncValue.data(newState);
  }

  void rotateSelectedOrientation() {
    final newState = state.value!.copyWith(
      selectedOrientation: state.value!.selectedOrientation == ShipOrientation.horizontal
          ? ShipOrientation.vertical
          : ShipOrientation.horizontal,
    );
    state = AsyncValue.data(newState);
  }

  void removeLastShip() {
    if (state.value!.ships.isNotEmpty) {
      final last = state.value!.ships.removeLast();
      Map<int, int> newShipsToPlace = {...state.value!.shipsToPlace, last.size: state.value!.shipsToPlace[last.size]! + 1};

      final newState = state.value!.copyWith(
        ships: state.value!.ships,
        shipsToPlace: newShipsToPlace,
      );
      state = AsyncValue.data(newState);
    }
  }

  void autoPlaceShips() {
    Map<int, int> shipsToPlaceTmp = {...state.value!.shipsToPlace};
    for (final size in [4, 3, 2, 1]) {
      for (int ship = 0; ship < shipsToPlaceTmp[size]!; ship++) {
        bool shipWasPlaced = false;
        while (!shipWasPlaced) {
          int x = Random().nextInt(10);
          int y = Random().nextInt(10);
          ShipOrientation orientation = Random().nextBool() ? ShipOrientation.horizontal : ShipOrientation.vertical;
          if (canPlaceShip(x, y, size, orientation)) {

            final newState = state.value!.copyWith(
              ships: [...state.value!.ships, Ship(x, y, size, orientation)],
              shipsToPlace: {...state.value!.shipsToPlace, size: state.value!.shipsToPlace[size]! - 1},
            );
            shipWasPlaced = true;
            state = AsyncValue.data(newState);
          }
        }
      }
    }
  }

  int countNeedPlaceShips() {
    int count = 0;
    for (final size in [4, 3, 2, 1]) {
      count += state.value?.shipsToPlace[size] ?? 0;
    }
    return count;
  }

  void clearShips() {
    final newState = state.value!.copyWith(
      ships: [],
      shipsToPlace: shipsToPlaceDefault,
    );
    state = AsyncValue.data(newState);
  }
}

final setupShipsViewModelProvider = AsyncNotifierProvider<SetupShipsViewModelNotifier, SetupShipsViewModelState>(() {
  return SetupShipsViewModelNotifier();
});