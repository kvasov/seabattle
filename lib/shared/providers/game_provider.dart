import 'package:flutter/material.dart';
import 'package:seabattle/features/ships_setup/presentation/viewmodels/setup_ships_viewmodel.dart';
import 'package:seabattle/shared/entities/game.dart';
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
    state = const AsyncValue.loading();
    try {
      // TODO: handle error
      final game = await ref.read(prepareRepositoryProvider).createGame();

      // ONLY FOR TESTING
      final newGame = game.data?.copyWith(id: 6, master: true);
      final newState = GameState(
        game: newGame,
        isLoading: false,
        isError: false,
        errorMessage: '',
      );
      ref.read(webSocketNotifierProvider.notifier).connect(newGame!.id);

      // final newState = GameState(game: game.data, isLoading: false, isError: false, errorMessage: '');
      // ref.read(webSocketNotifierProvider.notifier).connect(game.data!.id);

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
    state = const AsyncValue.loading();
    try {
      final game = await ref.read(prepareRepositoryProvider).updateGame(id, action, ref.read(userUniqueIdProvider));
      if (game.isSuccess) {
        debugPrint('❤️❤️❤️ updateGame - success');
        state = AsyncValue.data(
          GameState(
            game: game.data,
            isLoading: false,
            isError: false,
            errorMessage: '',
          ),
        );

        if (action == GameAction.accept) {
          // Принимаем игру, подключаемся к WebSocket
          ref.read(webSocketNotifierProvider.notifier).connect(game.data!.id);
          // Переходим на экран расстановки кораблей
          ref.read(navigationProvider.notifier).pushSetupShipsScreen();
          // Игру принять может только slave
          updateGameMaster(false);
        } else if (action == GameAction.cancel) {
          debugPrint('🚫🚫🚫🚫🚫🚫 updateGame - cancel');
          resetGame();
        }
      }
      else if (game.isError) {
        final failure = game.error;
        debugPrint('🤍🤍🤍🤍🤍🤍 updateGame - error: ${failure?.description ?? 'Неизвестная ошибка'}');
        if (failure?.description == 'already_accepted') {
          ref.read(navigationProvider.notifier).pushAcceptedGameDialogScreen();
        }
        state = AsyncValue.error(game.error.toString(), StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }



  // Режим игрока master/slave
  void updateGameMaster(bool master) {
    state = const AsyncValue.loading();
    try {
      final newGame = state.value?.game?.copyWith(master: master);
      final newState = GameState(
        game: newGame,
        isLoading: false,
        isError: false,
        errorMessage: '',
      );
      state = AsyncValue.data(newState);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> startGame() async {
    final newGame = state.value?.game?.copyWith(ready: true);

    state = const AsyncValue.loading();
    // Нужно отправить данные о своих кораблях сопернику
    await ref.read(prepareRepositoryProvider).sendShipsToOpponent(
      state.value?.game?.id ?? 0,
      ref.read(userUniqueIdProvider),
      ref.read(setupShipsViewModelProvider.notifier).state.value?.ships ?? []
    );
    // Перемещаем свои корабли в BattleViewModelNotifier
    ref.read(battleViewModelProvider.notifier)
      ..setShips(
        mode: 'self',
        ships: ref.read(setupShipsViewModelProvider.notifier).state.value?.ships ?? []
      )
      ..setMyMove(!(state.value!.game!.master ?? false));
    ref.read(navigationProvider.notifier).pushBattleScreen();

    final newState = GameState(
      game: newGame,
      isLoading: false,
      isError: false,
      errorMessage: '',
    );
    state = AsyncValue.data(newState);
  }

  void cancelGame() {
    debugPrint('🚫 cancelGame');
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
      ref.read(navigationProvider.notifier).pushHomeScreen();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final gameNotifierProvider = AsyncNotifierProvider<GameNotifier, GameState>(() {
  return GameNotifier();
});