import 'package:seabattle/core/constants/ships.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/shared/providers/ble_provider.dart';
import 'package:seabattle/shared/providers/ui_provider.dart';
import 'package:seabattle/utils/cursor_position_utils.dart';
import 'package:seabattle/utils/ship_placement_utils.dart';
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
  final GridPosition? cursorPosition;
  final bool? isCursorVisible;

  SetupShipsViewModelState({
    required this.ships,
    required this.shipsToPlace,
    required this.selectedOrientation,
    required this.selectedShipSize,
    required this.isLoading,
    required this.isError,
    required this.errorMessage,
    required this.gridSize,
    this.cursorPosition,
    this.isCursorVisible,
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
    GridPosition? cursorPosition,
    bool? isCursorVisible,
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
      cursorPosition: cursorPosition ?? this.cursorPosition,
      isCursorVisible: isCursorVisible ?? this.isCursorVisible,
    );
  }
}

class SetupShipsViewModelNotifier extends AsyncNotifier<SetupShipsViewModelState> {
  @override
  Future<SetupShipsViewModelState> build() async {
    // Проверяем состояние подключения ESP (по умолчанию false, если провайдер еще не инициализирован)
    final bleStateAsync = ref.read(bleNotifierProvider);
    final isConnected = bleStateAsync.value?.isConnected ?? false;
    debugPrint('💚! isConnected: $isConnected');

    return SetupShipsViewModelState(
      ships: [],
      shipsToPlace: shipsToPlaceDefault,
      selectedOrientation: ShipOrientation.horizontal,
      selectedShipSize: 4,
      gridSize: 10,
      isLoading: false,
      isError: false,
      errorMessage: '',
      cursorPosition: GridPosition(0, 0),
      isCursorVisible: isConnected,
    );
  }

  void updateIsConnected(bool isConnected) {
    final newState = state.value!.copyWith(isCursorVisible: isConnected);
    state = AsyncValue.data(newState);
  }

  void handleESP32Message(String value) {
    // debugPrint('⌖ handleESP32Message: $value');
    if (value == 'fire') {
      if (canPlaceShip(state.value!.cursorPosition!.x, state.value!.cursorPosition!.y, state.value!.selectedShipSize, state.value!.selectedOrientation)) {
        placeShip(state.value!.cursorPosition!.x, state.value!.cursorPosition!.y);
        if (countNeedPlaceShips() == 0) {
          state = AsyncValue.data(
            state.value!.copyWith(isCursorVisible: false),
          );
        }
      }
    } else {
      setCursorPosition(value);
    }
  }

  void setCursorPosition(String value) {
    final newCursorPosition = calculateNewCursorPosition(
      state.value!.cursorPosition,
      value,
      state.value!.gridSize,
    );
    final newState = state.value!.copyWith(
      cursorPosition: newCursorPosition,
    );
    state = AsyncValue.data(newState);
  }

  bool canPlaceShip(int x, int y, int size, ShipOrientation orientation) {
    // Используем чистую функцию, которая может работать и в изоляте
    return canPlaceShipPure(
      x,
      y,
      size,
      orientation,
      state.value!.ships,
      state.value!.gridSize,
    );
  }

  void handleTapDown(TapDownDetails details) {
    final localPosition = details.localPosition;
    debugPrint('⌖ localPosition: $localPosition');

    final cellSize = ref.watch(cellSizeProvider);
    final x = (localPosition.dx ~/ cellSize).clamp(0, state.value!.gridSize - 1);
    final y = (localPosition.dy ~/ cellSize).clamp(0, state.value!.gridSize - 1);
    debugPrint('⌖ x: $x, y: $y');
    // Получаем глобальные координаты относительно экрана
    // final globalPosition = details.globalPosition;
    // debugPrint('⌖ globalPosition: $globalPosition');

    if (state.value!.isCursorVisible == false) {
      placeShip(x, y);
    }
  }

  void placeShip(int x, int y) {
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

      // Если все корабли размещены, оставляем текущий selectedShipSize
      // чтобы избежать проблем с null
      final finalSelectedShipSize = newSelectedShipSize ?? state.value!.selectedShipSize;

      final newState = state.value!.copyWith(
        ships: [...state.value!.ships, Ship(x, y, state.value!.selectedShipSize, state.value!.selectedOrientation)],
        shipsToPlace: newShipsToPlace,
        selectedShipSize: finalSelectedShipSize,
      );

      state = AsyncValue.data(newState);
      firstAvailablePosition();
      if (countNeedPlaceShips() == 0) {
        state = AsyncValue.data(
          state.value!.copyWith(isCursorVisible: false),
        );
      }
    }
  }

  void firstAvailablePosition() {
    final startY = state.value!.cursorPosition!.y;
    final startX = state.value!.cursorPosition!.x;
    int y = startY;
    int iterations = 0;
    const maxIterations = 1000; // Защита от бесконечного цикла

    while (iterations < maxIterations) {
      // Начинаем с текущей позиции x для первой строки, затем с 0 для остальных
      final startXForRow = (y == startY) ? startX : 0;

      for (int x = startXForRow; x < state.value!.gridSize; x++) {
        if (canPlaceShip(x, y, state.value!.selectedShipSize, state.value!.selectedOrientation)) {
          GridPosition newCursorPosition = GridPosition(x, y);
          state = AsyncValue.data(
            state.value!.copyWith(cursorPosition: newCursorPosition),
          );
          return; // Нашли позицию, выходим
        }
      }

      // Переходим на следующую строку
      y++;
      if (y >= state.value!.gridSize) {
        y = 0;
      }

      // Если вернулись к начальной позиции, значит проверили все поле
      if (y == startY && iterations > 0) {
        debugPrint('⚠️ firstAvailablePosition: Не найдено доступной позиции для размещения корабля');
        return;
      }

      iterations++;
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

      final isConnected = ref.read(bleNotifierProvider).value?.isConnected ?? false;
      final newState = state.value!.copyWith(
        ships: state.value!.ships,
        shipsToPlace: newShipsToPlace,
        isCursorVisible: isConnected,
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

      state = AsyncValue.data(
        state.value!.copyWith(isCursorVisible: false),
      );
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
    final isConnected = ref.read(bleNotifierProvider).value?.isConnected ?? false;
    final newState = state.value!.copyWith(
      ships: [],
      shipsToPlace: shipsToPlaceDefault,
      isCursorVisible: isConnected,
    );
    state = AsyncValue.data(newState);
  }
}

final setupShipsViewModelProvider = AsyncNotifierProvider<SetupShipsViewModelNotifier, SetupShipsViewModelState>(() {
  return SetupShipsViewModelNotifier();
});