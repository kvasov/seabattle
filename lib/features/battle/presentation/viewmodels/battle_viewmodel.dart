import 'package:seabattle/shared/entities/ship.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BattleViewModelState {
  final List<Ship> ships;
  final List<Shot> shots;
  final List<Ship> opponentShips;
  final List<Shot> opponentShots;
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final int gridSize;
  final double cellSize;

  BattleViewModelState({
    required this.ships,
    required this.shots,
    required this.opponentShips,
    required this.opponentShots,
    required this.isLoading,
    required this.isError,
    required this.errorMessage,
    required this.gridSize,
    required this.cellSize,
  });

  BattleViewModelState copyWith({
    List<Ship>? ships,
    List<Shot>? shots,
    List<Ship>? opponentShips,
    List<Shot>? opponentShots,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    int? gridSize,
    double? cellSize,
  }) {
    return BattleViewModelState(
      ships: ships ?? this.ships,
      shots: shots ?? this.shots,
      opponentShips: opponentShips ?? this.opponentShips,
      opponentShots: opponentShots ?? this.opponentShots,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      gridSize: gridSize ?? this.gridSize,
      cellSize: cellSize ?? this.cellSize,
    );
  }

  @override
  String toString() {
    return 'BattleViewModelState(ships: ${ships.length}, shots: ${shots.length}, opponentShips: ${opponentShips.length}, opponentShots: ${opponentShots.length}, isLoading: $isLoading, isError: $isError, errorMessage: $errorMessage, gridSize: $gridSize, cellSize: $cellSize)';
  }
}

class BattleViewModelNotifier extends AsyncNotifier<BattleViewModelState> {
  @override
  Future<BattleViewModelState> build() async {
    return _initialState();
  }

  void setShips({required String mode, required List<Ship> ships}) {
    final currentState = _currentState();
    state = AsyncValue.data(
      mode == 'self'
          ? currentState.copyWith(ships: ships)
          : currentState.copyWith(opponentShips: ships),
    );

    debugPrint('💚 state: ${state.value?.toString()}');
  }

  void handleTapDown(TapDownDetails details) {
    final localPosition = details.localPosition;
    debugPrint('⌖ localPosition: $localPosition');
    final x = (localPosition.dx ~/ state.value!.cellSize).clamp(0, state.value!.gridSize - 1);
    final y = (localPosition.dy ~/ state.value!.cellSize).clamp(0, state.value!.gridSize - 1);
    debugPrint('⌖ x: $x, y: $y');
    final globalPosition = details.globalPosition;
    debugPrint('⌖ globalPosition: $globalPosition');

    final shot = Shot(x, y);
    state = AsyncValue.data(
      state.value!.copyWith(shots: [...state.value!.shots, shot]),
    );

    if (isHit(x, y)) {
      debugPrint('🎯 hit');
    } else {
      debugPrint('🙅🏻‍♂️ miss');
    }

    debugPrint('💚 state: ${state.value?.toString()}');
  }

  bool isHit(int x, int y) {
    if (state.value?.opponentShips.any((ship) => ship.contains(x, y)) ?? false) {
      debugPrint('🎯 ship: ${state.value?.opponentShips.firstWhere((ship) => ship.contains(x, y)).toString()}');
      return true;
    } else {
      return false;
    }
  }
  void resetBattle() {
    state = AsyncValue.data(
      _initialState(),
    );
  }

  BattleViewModelState _currentState() {
    return state.maybeWhen(
      data: (value) => value,
      orElse: () => _initialState(),
    );
  }

  BattleViewModelState _initialState() {
    return BattleViewModelState(
      ships: [],
      shots: [],
      opponentShips: [],
      opponentShots: [],
      gridSize: 10,
      cellSize: 32,
      isLoading: false,
      isError: false,
      errorMessage: '',
    );
  }
}

