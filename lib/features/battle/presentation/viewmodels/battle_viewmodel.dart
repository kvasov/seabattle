import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/core/constants/ships.dart';
import 'package:seabattle/shared/entities/ship.dart';
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
import 'package:seabattle/shared/providers/sound_provider.dart';

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
  final bool? showDeathOfShip;
  final Ship? lastDeadShip;
  final bool showFirework;

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
    this.showDeathOfShip = false,
    this.lastDeadShip,
    this.showFirework = false,
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
    bool? showDeathOfShip,
    Ship? lastDeadShip,
    bool? showFirework,
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
      showDeathOfShip: showDeathOfShip ?? this.showDeathOfShip,
      lastDeadShip: lastDeadShip ?? this.lastDeadShip,
      showFirework: showFirework ?? this.showFirework,
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

  // Обработка сообщения от ESP32
  Future<void> handleESP32Message(String value) async {
    if (value == 'fire') {
      if (!state.value!.myMove) {
        return;
      }
      await makeShot(state.value!.cursorPosition!.x, state.value!.cursorPosition!.y);
    } else {
      setCursorPosition(value);
    }
  }

  // Установка курсора при получении сообщения от ESP32
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

  // Установка кораблей (собственные или противника)
  void setShips({required String mode, required List<Ship> ships}) {
    final currentState = _currentState();
    state = AsyncValue.data(
      mode == 'self'
        ? currentState.copyWith(ships: ships)
        : currentState.copyWith(opponentShips: ships),
    );
  }

  // Выстрел по координатам тапа
  Future<void> handleTapDown(TapDownDetails details) async {
    final accelerometerData = ref.read(accelerometerNotifierProvider).value;
    final isConnected = ref.read(bleNotifierProvider).value?.isConnected ?? false;
    if (!state.value!.myMove || isConnected || (accelerometerData?.isReceivingData ?? false)) {
      return;
    }
    final localPosition = details.localPosition;
    final cellSize = ref.watch(cellSizeProvider);
    final x = (localPosition.dx ~/ cellSize).clamp(0, state.value!.gridSize - 1);
    final y = (localPosition.dy ~/ cellSize).clamp(0, state.value!.gridSize - 1);
    // debugPrint('⌖ x: $x, y: $y');
    // final globalPosition = details.globalPosition;
    // debugPrint('⌖ globalPosition: $globalPosition');

    await makeShot(x, y);
  }

  // Выстрел по координатам шарика
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

  // Сам выстрел
  Future<void> makeShot(int x, int y) async {
    final shot = Shot(x, y);
    if (state.value?.shots.any((shot) => shot.x == x && shot.y == y) ?? false) {
      return;
    }
    final updatedShots = [...state.value!.shots, shot];


    if (isHit(x, y)) {
      await ref.read(statisticsViewModelProvider.notifier).incrementStatistic('totalHits');

      // Обновляем корабли противника, помечая мертвые как dead = true
      final updatedOpponentShips = state.value!.opponentShips.map((ship) {
        if (ship.isDead(updatedShots)) {
          ship.dead = true;
        }
        return ship;
      }).toList();

      int delay = 0;

      // Проверяем, был ли уничтожен корабль этим выстрелом
      for (var ship in updatedOpponentShips) {
        if (ship.isDeadByShot(shot, updatedShots)) {
          delay = 200;
          state = AsyncValue.data(
            state.value!.copyWith(showDeathOfShip: true, lastDeadShip: ship),
          );
          // уничтожаем виджет после завершения анимации появления и взрыва
          Future.delayed(const Duration(milliseconds: shipFadeInDuration + shipExplosionDuration), () {
            state = AsyncValue.data(
              state.value!.copyWith(showDeathOfShip: false, lastDeadShip: null),
            );
          });
        } else {
          delay = 0;
        }
      }

      Future.delayed(Duration(milliseconds: delay), () {
        state = AsyncValue.data(
          state.value!.copyWith(opponentShips: updatedOpponentShips, shots: updatedShots),
        );
      });
    } else {
      state = AsyncValue.data(
        state.value!.copyWith(shots: updatedShots),
      );
      setMyMove(false);
    }

    sendShot(x, y);
  }

  // Проверка на попадание
  bool isHit(int x, int y) {
    if (state.value?.opponentShips.any((ship) => ship.isWounded(x, y)) ?? false) {
      ref.read(vibrationNotifierProvider.notifier).vibrateHit();
      ref.read(soundNotifierProvider.notifier).playSound('hit');
      return true;
    } else {
      ref.read(vibrationNotifierProvider.notifier).vibrateMiss();
      ref.read(soundNotifierProvider.notifier).playSound('miss');
      return false;
    }
  }

  // Проверка на уничтожение всех кораблей противника
  bool allOpponentShipsDead() {
    if (state.value?.opponentShips.every((ship) => ship.isDead(state.value!.shots)) ?? false) {
      ref.read(vibrationNotifierProvider.notifier).vibrateDeath();
      return true;
    } else {
      return false;
    }
  }

  // Проверка на уничтожение всех своих кораблей
  bool allShipsDead() {
    if (state.value?.ships.every((ship) => ship.isDead(state.value!.opponentShots)) ?? false) {
      ref.read(vibrationNotifierProvider.notifier).vibrateDeath();
      return true;
    } else {
      return false;
    }
  }

  // Отправка выстрела
  Future<void> sendShot(int x, int y) async {
    final lastShot = Shot(x, y);
    state = AsyncValue.data(
      state.value!.copyWith(lastShot: lastShot),
    );
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
          Future.delayed(const Duration(milliseconds: shipExplosionDuration + shipFadeInDuration), () {
            ref.read(soundNotifierProvider.notifier).playSound('win');
            ref.read(navigationProvider.notifier).pushWinModal();
            ref.read(statisticsViewModelProvider.notifier).incrementStatistic('totalWins');
          });
        }
      }

    } catch (e) {
      debugPrint('💚❤️♠️ sendShot error: $e');
      state = AsyncValue.data(
        state.value!.copyWith(isError: true, errorMessage: e.toString()),
      );
    }
  }

  // Отправка последнего выстрела с экрана ошибки (в случае, если возникла ошибка при отправке выстрела)
  void sendLastShot() {
    final lastShot = state.value!.lastShot;
    if (lastShot != null) {
      sendShot(lastShot.x, lastShot.y);
    }
  }

  void addOpponentShot(int x, int y) {
    final shot = Shot(x, y);
    final updatedOpponentShots = [...state.value!.opponentShots, shot];

    // Обновляем свои корабли, помечая мертвые как dead = true
    final updatedShips = state.value!.ships.map((ship) {
      if (ship.isDead(updatedOpponentShots)) {
        ship.dead = true;
      }
      return ship;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        opponentShots: updatedOpponentShots,
        ships: updatedShips,
      ),
    );
  }

  void showFirework() {
    state = AsyncValue.data(
      state.value!.copyWith(showFirework: true),
    );
    Future.delayed(const Duration(milliseconds: 2200), () {
      state = AsyncValue.data(
        state.value!.copyWith(showFirework: false),
      );
    });
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

