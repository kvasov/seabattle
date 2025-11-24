import 'package:seabattle/shared/entities/ship.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/battle/providers/repositories/battle_repository_provider.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/providers/user_provider.dart';
import 'package:seabattle/shared/providers/vibration_provider.dart';
import 'package:seabattle/features/statistics/providers/statistics_provider.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/utils/cursor_position_utils.dart';
import 'package:seabattle/shared/providers/ble_provider.dart';
import 'package:seabattle/shared/providers/ui_provider.dart';
import 'package:seabattle/shared/providers/accelerometer_provider.dart';

class BattleViewModelState {
  final List<Ship> ships;
  final List<Shot> shots;
  final List<Ship> opponentShips;
  final List<Shot> opponentShots;
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final int gridSize;
  final bool myMove;
  final GridPosition? cursorPosition;
  final Shot? lastShot;

  BattleViewModelState({
    required this.ships,
    required this.shots,
    required this.opponentShips,
    required this.opponentShots,
    required this.isLoading,
    required this.isError,
    required this.errorMessage,
    required this.gridSize,
    required this.myMove,
    this.cursorPosition,
    this.lastShot,
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
    bool? myMove,
    GridPosition? cursorPosition,
    Shot? lastShot,
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
      myMove: myMove ?? this.myMove,
      cursorPosition: cursorPosition ?? this.cursorPosition,
      lastShot: lastShot ?? this.lastShot,
    );
  }

  @override
  String toString() {
    return '''BattleViewModelState(
     ships: ${ships.length},
     shots: ${shots.length},
     opponentShips: ${opponentShips.length},
     opponentShots: ${opponentShots.length},
     isLoading: $isLoading,
     isError: $isError,
     errorMessage: $errorMessage,
     gridSize: $gridSize, myMove: $myMove, cursorPosition: $cursorPosition, lastShot: $lastShot)''';
  }
}

class BattleViewModelNotifier extends AsyncNotifier<BattleViewModelState> {
  @override
  Future<BattleViewModelState> build() async {
    return _initialState();
  }

  Future<void> handleESP32Message(String value) async {
    // debugPrint('⌖ handleESP32Message: $value');
    if (value == 'fire') {
      if (!state.value!.myMove) {
        return;
      }
      await makeShot(state.value!.cursorPosition!.x, state.value!.cursorPosition!.y);
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

  void setShips({required String mode, required List<Ship> ships}) {
    final currentState = _currentState();
    state = AsyncValue.data(
      mode == 'self'
          ? currentState.copyWith(ships: ships)
          : currentState.copyWith(opponentShips: ships),
    );
  }

  Future<void> handleTapDown(TapDownDetails details) async {
    final accelerometerData = ref.read(accelerometerNotifierProvider).value;
    final isConnected = ref.read(bleNotifierProvider).value?.isConnected ?? false;
    if (!state.value!.myMove || isConnected || (accelerometerData?.isReceivingData ?? false)) {
      return;
    }
    final localPosition = details.localPosition;
    // debugPrint('⌖ localPosition: $localPosition');
    final cellSize = ref.watch(cellSizeProvider);
    final x = (localPosition.dx ~/ cellSize).clamp(0, state.value!.gridSize - 1);
    final y = (localPosition.dy ~/ cellSize).clamp(0, state.value!.gridSize - 1);
    // debugPrint('⌖ x: $x, y: $y');
    // final globalPosition = details.globalPosition;
    // debugPrint('⌖ globalPosition: $globalPosition');

    await makeShot(x, y);

    // debugPrint('💚 state: ${state.value?.toString()}');
  }

  Future<void> handleBallTapDown(int ballX, int ballY) async {
    debugPrint('💚❤️ handleBallTapDown: $ballX, $ballY');
    if (!state.value!.myMove) {
      return;
    }
    final cellSize = ref.watch(cellSizeProvider);
    final x = (ballX ~/ cellSize).clamp(0, state.value!.gridSize - 1);
    final y = (ballY ~/ cellSize).clamp(0, state.value!.gridSize - 1);
    debugPrint('💚❤️ x: $x, y: $y');
    await makeShot(x, y);
  }

  Future<void> makeShot(int x, int y) async {
    debugPrint('💚❤️ makeShot: $x, $y');
    final shot = Shot(x, y);
    if (state.value?.shots.any((shot) => shot.x == x && shot.y == y) ?? false) {
      return;
    }
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
  }

  bool isHit(int x, int y) {
    if (state.value?.opponentShips.any((ship) => ship.isWounded(x, y)) ?? false) {
      ref.read(vibrationNotifierProvider.notifier).vibrateHit();
      return true;
    } else {
      ref.read(vibrationNotifierProvider.notifier).vibrateMiss();
      return false;
    }
  }

  bool allOpponentShipsDead() {
    if (state.value?.opponentShips.every((ship) => ship.isDead(state.value!.shots)) ?? false) {
      ref.read(vibrationNotifierProvider.notifier).vibrateDeath();
      return true;
    } else {
      return false;
    }
  }

  bool allShipsDead() {
    if (state.value?.ships.every((ship) => ship.isDead(state.value!.opponentShots)) ?? false) {
      ref.read(vibrationNotifierProvider.notifier).vibrateDeath();
      return true;
    } else {
      return false;
    }
  }

  Future<void> sendShot(int x, int y) async {
    final lastShot = Shot(x, y);
    state = AsyncValue.data(
      state.value!.copyWith(lastShot: lastShot),
    );
    debugPrint('💚❤️ sendShot: $x, $y');
    final id = ref.read(gameNotifierProvider).value?.game?.id ?? 0;
    final userUniqueId = ref.read(userUniqueIdProvider);
    // debugPrint('💚 sendShot - вызов');
    // state = const AsyncValue.loading();
    try {
      final result = await ref.read(battleRepositoryProvider).sendShotToOpponent(id, userUniqueId, x, y, isHit(x, y));
      if (result.isError) {
        debugPrint('💚❤️♠️ sendShot error: ${result.error?.description ?? 'Unknown error'}');
        state = AsyncValue.data(
          state.value!.copyWith(isError: true, errorMessage: result.error?.description ?? 'Unknown error'),
        );
      } else {
        state = AsyncValue.data(
          state.value!.copyWith(isError: false, errorMessage: ''),
        );
        await ref.read(statisticsViewModelProvider.notifier).incrementStatistic('totalShots');
        if (allOpponentShipsDead()) {
          // debugPrint('🎉 WIN!!!');
          ref.read(navigationProvider.notifier).pushWinModal();
          await ref.read(statisticsViewModelProvider.notifier).incrementStatistic('totalWins');
        }
      }

    } catch (e) {
      debugPrint('💚❤️♠️ sendShot error: $e');
      state = AsyncValue.data(
        state.value!.copyWith(isError: true, errorMessage: e.toString()),
      );
    }
  }

  void sendLastShot() {
    debugPrint('💚❤️♠️ sendLastShot');
    final lastShot = state.value!.lastShot;
    debugPrint('💚❤️♠️ lastShot: $lastShot');
    if (lastShot != null) {
      debugPrint('💚❤️♠️ sendLastShot - вызов sendShot');
      sendShot(lastShot.x, lastShot.y);
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
      isLoading: false,
      isError: false,
      errorMessage: '',
      myMove: false,
      cursorPosition: GridPosition(0, 0),
    );
  }
}

