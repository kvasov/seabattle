import 'package:flutter/foundation.dart';
import 'package:seabattle/features/statistics/providers/statistics_provider.dart';
import 'package:seabattle/features/ships_setup/presentation/viewmodels/setup_ships_viewmodel.dart';
import 'package:seabattle/shared/entities/game.dart';
import 'package:seabattle/shared/providers/accelerometer_provider.dart';
import 'package:seabattle/shared/providers/cheater_provider.dart';
import 'package:seabattle/shared/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/shared/providers/web_socket_provider.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';
import 'package:seabattle/shared/providers/repositories/prepare_repository_provider.dart';

class GameState {
  final GameModel? game;
  final bool isLoading;
  final bool isError;
  final String errorMessage;

  GameState({
    this.game,
    required this.isLoading,
    required this.isError,
    required this.errorMessage,
  });

  GameState copyWith({
    GameModel? game,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
  }) {
    return GameState(
      game: game ?? this.game,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class GameNotifier extends AsyncNotifier<GameState> {
  @override
  Future<GameState> build() async {
    return GameState(
      game: null,
      isLoading: false,
      isError: false,
      errorMessage: '',
    );
  }

  Future<void> createGame() async {
    final currentState = state.value;
    state = const AsyncValue.loading();
    try {
      final game = await ref.read(prepareRepositoryProvider).createGame();
      final gameWithMaster = game.data?.copyWith(master: true);
      final newState = currentState!.copyWith(
        game: gameWithMaster,
      );
      ref.read(webSocketNotifierProvider.notifier).connect(game.data!.id);
      state = AsyncValue.data(newState);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> setOpponentReady() async {
    final newGame = state.value?.game?.copyWith(opponentReady: true);
    state = AsyncValue.data(state.value!.copyWith(game: newGame));
  }

  Future<void> updateGame(int id, GameAction action) async {
    debugPrint('🔄🤍 updateGame: id: $id, action: $action');
    final currentState = state.value;
    state = const AsyncValue.loading();
    try {
      final game = await ref.read(prepareRepositoryProvider).updateGame(id, action, ref.read(userUniqueIdProvider));
      debugPrint('🔄🤍 updateGame: получен результат - isSuccess: ${game.isSuccess}, isError: ${game.isError}, data: ${game.data}, error: ${game.error}');
      debugPrint('🔄🤍 updateGame: currentState = $currentState');
      if (game.isSuccess) {
        // Создаем новое состояние, используя currentState если он есть, иначе создаем новое
        final newState = currentState?.copyWith(
          game: game.data,
        ) ?? GameState(
          game: game.data,
          isLoading: false,
          isError: false,
          errorMessage: '',
        );
        state = AsyncValue.data(newState);
        debugPrint('🔄🤍!!!!!!!!!! updateGame: id: $id, action: $action');
        if (action == GameAction.accept) {
          debugPrint('🔄🤍 updateGame: action == GameAction.accept');
          // Игру принять может только slave - обновляем master флаг перед переходом
          final gameWithMaster = game.data!.copyWith(master: false);
          state = AsyncValue.data(
            newState.copyWith(
              game: gameWithMaster,
            ),
          );

          ref.read(webSocketNotifierProvider.notifier).connect(game.data!.id);
          // Увеличиваем общее количество игр в стейте и сохраняем в базу данных
          // но сначала убеждаемся, что провайдер статистики инициализирован
          final statisticsState = ref.read(statisticsViewModelProvider);
          if (!statisticsState.hasValue) {
            await ref.read(statisticsViewModelProvider.future);
          }
          await ref.read(statisticsViewModelProvider.notifier).incrementStatistic('totalGames');

          // Переход на экран расстановки кораблей после всех обновлений
          ref.read(navigationProvider.notifier).goToSetupShipsScreen();
        } else if (action == GameAction.cancel) {
          resetGame();
        }
      }
      else if (game.isError) {
        debugPrint('🔄🤍 updateGame: ошибка - ${game.error}');
        final failure = game.error;
        if (failure?.description == 'already_accepted') {
          ref.read(navigationProvider.notifier).pushAcceptedGameDialogScreen();
        } else if (failure?.description == 'cancelled') {
          ref.read(navigationProvider.notifier).pushCanceledGameDialogScreen();
        }
        state = AsyncValue.error(game.error.toString(), StackTrace.current);
      } else {
        debugPrint('🔄🤍 updateGame: неизвестное состояние - ни success, ни error');
      }
    } catch (e, stackTrace) {
      debugPrint('🔄🤍 updateGame: исключение - $e');
      debugPrint('🔄🤍 updateGame: stackTrace - $stackTrace');
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  // Режим игрока master/slave
  void updateGameMaster(bool master) {
    final currentState = state.value;
    state = const AsyncValue.loading();
    try {
      final newGame = currentState?.game?.copyWith(master: master);
      final newState = currentState!.copyWith(
        game: newGame,
      );
      state = AsyncValue.data(newState);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> startGame() async {
    final currentState = state.value;
    final newGame = state.value?.game?.copyWith(ready: true);

    state = const AsyncValue.loading();
    // Нужно отправить данные о своих кораблях сопернику
    await ref.read(prepareRepositoryProvider).sendShipsToOpponent(
      state.value?.game?.id ?? 0,
      ref.read(userUniqueIdProvider),
      ref.read(setupShipsViewModelProvider.notifier).state.value?.ships ?? []
    );
    // Перемещаем свои корабли в BattleViewModelNotifier
    final isMaster = state.value!.game!.master ?? false;
    final myMove = !isMaster;
    ref.read(battleViewModelProvider.notifier)
      ..setShips(
        mode: 'self',
        ships: ref.read(setupShipsViewModelProvider.notifier).state.value?.ships ?? []
      )
      ..setMyMove(myMove);
    ref.read(navigationProvider.notifier).pushBattleScreen();

    final newState = currentState!.copyWith(game: newGame);
    state = AsyncValue.data(newState);
  }

  void cancelGame() {
    ref.read(navigationProvider.notifier).pushCancelGameDialogScreen();
  }

  void resetGame() {
    state = const AsyncValue.loading();
    try {
      final newState = GameState(
        game: null,
        isLoading: false,
        isError: false,
        errorMessage: '',
      );
      state = AsyncValue.data(newState);

      final setupShipsState = ref.read(setupShipsViewModelProvider);
      final battleState = ref.read(battleViewModelProvider);

      if (setupShipsState.hasValue) {
        ref.read(setupShipsViewModelProvider.notifier).clearShips();
      }
      if (battleState.hasValue) {
        ref.read(battleViewModelProvider.notifier).resetBattle();
      }
      ref.read(cheaterProvider.notifier).resetCheaterMode();
      ref.read(accelerometerNotifierProvider.notifier).disconnect();
      ref.read(navigationProvider.notifier).goToHomeScreen();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final gameNotifierProvider = AsyncNotifierProvider<GameNotifier, GameState>(() {
  return GameNotifier();
});