import 'package:seabattle/shared/entities/ship.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/battle/providers/repositories/battle_repository_provider.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/providers/user_provider.dart';
import 'package:seabattle/features/statistics/providers/statistics_provider.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';

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
  final bool myMove;

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
    required this.myMove,
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
    bool? myMove,
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
      myMove: myMove ?? this.myMove,
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

  Future<void> handleTapDown(TapDownDetails details) async {
    if (!state.value!.myMove) {
      return;
    }
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
      await ref.read(statisticsViewModelProvider.notifier).incrementStatistic('totalHits');
      setMyMove(true);
    } else {
      setMyMove(false);
    }

    sendShot(x, y);

    debugPrint('💚 state: ${state.value?.toString()}');
  }

  bool isHit(int x, int y) {
    if (state.value?.opponentShips.any((ship) => ship.isWounded(x, y)) ?? false) {
      return true;
    } else {
      return false;
    }
  }

  bool allOpponentShipsDead() {
    return state.value?.opponentShips.every((ship) => ship.isDead(state.value!.shots)) ?? false;
  }

  bool allShipsDead() {
    return state.value?.ships.every((ship) => ship.isDead(state.value!.opponentShots)) ?? false;
  }

  Future<void> sendShot(int x, int y) async {
    final id = ref.read(gameNotifierProvider).value?.game?.id ?? 0;
    final userUniqueId = ref.read(userUniqueIdProvider);
    debugPrint('💚 sendShot - вызов');
    state = const AsyncValue.loading();
    try {
      await ref.read(battleRepositoryProvider).sendShotToOpponent(id, userUniqueId, x, y, isHit(x, y));
      await ref.read(statisticsViewModelProvider.notifier).incrementStatistic('totalShots');
      if (allOpponentShipsDead()) {
        debugPrint('🎉 WIN!!!');
        ref.read(navigationProvider.notifier).pushWinModal();
        await ref.read(statisticsViewModelProvider.notifier).incrementStatistic('totalWins');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void addOpponentShot(int x, int y) {
    state = AsyncValue.data(
      state.value!.copyWith(opponentShots: [...state.value!.opponentShots, Shot(x, y)]),
    );
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

  void setMyMove(bool value) {
    final current = _currentState();
    state = AsyncValue.data(
      current.copyWith(myMove: value),
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
      myMove: false,
    );
  }
}

