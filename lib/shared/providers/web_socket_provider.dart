import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:convert';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/shared/providers/user_provider.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/providers/ble_provider.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';
import 'package:seabattle/features/statistics/providers/statistics_provider.dart';
import 'package:seabattle/core/constants/host.dart';

class WebSocketState {
  final WebSocketChannel? channel;
  final bool isConnected;
  final bool isError;
  final String errorMessage;

  WebSocketState({
    this.channel,
    required this.isConnected,
    required this.isError,
    required this.errorMessage,
  });
}

class WebSocketNotifier extends AsyncNotifier<WebSocketState> {
  StreamSubscription<dynamic>? _subscription;
  WebSocketChannel? _currentChannel;

  @override
  Future<WebSocketState> build() async {
    ref.onDispose(() {
      debugPrint('🔌 WebSocket: autoDispose - автоматическое отключение');
      // Используем синхронный вызов для onDispose
      _subscription?.cancel();
      _subscription = null;
      try {
        _currentChannel?.sink.close();
      } catch (e) {
        debugPrint('⚠️ Ошибка при закрытии WebSocket в onDispose: $e');
      }
      _currentChannel = null;
    });

    return WebSocketState(channel: null, isConnected: false, isError: false, errorMessage: '');
  }

  Future<void> connect(int gameId) async {
    debugPrint('☎️ WebSocket connect: $gameId');

    // Отключаем предыдущее соединение, если оно есть
    await disconnect();

    state = const AsyncValue.loading();
    try {
      final channel = WebSocketChannel.connect(Uri.parse('ws://$host/ws'));
      _currentChannel = channel;

      // Сохраняем подписку для возможности отмены
      _subscription = channel.stream.listen(
        (data) async {
          // debugPrint('☎️ WebSocket raw data: $data');
          try {
            final decoded = json.decode(data);
            // debugPrint('☎️ WebSocket decoded: $decoded');
            if (decoded['mode'] == 'accepted') {
              final statisticsState = ref.read(statisticsViewModelProvider);
              if (!statisticsState.hasValue) {
                debugPrint('Провайдер статистики не инициализирован, инициализируем...');
                await ref.read(statisticsViewModelProvider.future);
              }
              await ref.read(statisticsViewModelProvider.notifier).incrementStatistic('totalGames');
              ref.read(navigationProvider.notifier).goToSetupShipsScreen();
            }
            if (decoded['mode'] == 'cancelled') {
              await ref.read(statisticsViewModelProvider.notifier).incrementStatistic('totalCancelled');

              if (decoded['userUniqueId'] != ref.read(userUniqueIdProvider)) {
                // Если игру отменили не мы, то показываем сообщение
                ref.read(navigationProvider.notifier).pushCanceledGameDialogScreen();
              }
            }
            // Если соперник отправил корабли, то обновляем состояние
            if (decoded['ships'] != null) {
              if (decoded['userUniqueId'] != ref.read(userUniqueIdProvider)) {
                final shipsRaw = decoded['ships'] as List<dynamic>;
                debugPrint('💚 Получены корабли соперника');
                debugPrint('💚 shipsRaw: $shipsRaw');
                final opponentShips = shipsRaw
                    .map((ship) => Ship.fromJson(Map<String, dynamic>.from(ship as Map<String, dynamic>)))
                    .toList();

                final gameNotifier = ref.read(gameNotifierProvider.notifier);
                final gameState = gameNotifier.state.value;
                if (gameState != null) {
                  debugPrint('💚 Устанавливаем корабли соперника: ${opponentShips}');
                  ref.read(battleViewModelProvider.notifier).setShips(
                    mode: 'opponent',
                    ships: opponentShips
                  );
                  debugPrint('💚 Установлены корабли соперника: ${ref.read(battleViewModelProvider).value?.opponentShips}');
                  gameNotifier.setOpponentReady();

                  debugPrint('💚 opponentShips: $opponentShips');
                } else {
                  debugPrint('⚠️ opponentShips получены, но GameState ещё не инициализирован');
                }
              }

            }
            // Если соперник отправил выстрел, то обновляем состояние
            if (decoded['type'] == 'shot' && decoded['x'] != null && decoded['y'] != null) {
              if (decoded['userUniqueId'] != ref.read(userUniqueIdProvider)) {
                final shotX = decoded['x'] as int;
                final shotY = decoded['y'] as int;

                final battleViewModelNotifier = ref.read(battleViewModelProvider.notifier);
                battleViewModelNotifier.addOpponentShot(shotX, shotY);

                if (decoded['isHit'] == true) {
                  ref.read(bleNotifierProvider.notifier).sendInt(1);
                  battleViewModelNotifier.setMyMove(false);
                  if (battleViewModelNotifier.allShipsDead()) {
                    await ref.read(statisticsViewModelProvider.notifier).incrementStatistic('totalLosses');
                    ref.read(navigationProvider.notifier).pushLoseModal();
                  }
                } else {
                  battleViewModelNotifier.setMyMove(true);
                }
              }
            }
          } catch (e) {
            debugPrint('⚠️ Ошибка при обработке данных WebSocket: $e');
          }
        },
        onError: (error) {
          debugPrint('❌ WebSocket error: $error');
          state = AsyncValue.data(WebSocketState(
            channel: null,
            isConnected: false,
            isError: true,
            errorMessage: error.toString(),
          ));
        },
        onDone: () {
          debugPrint('🔌 WebSocket closed: ${channel.closeReason}');
          state = AsyncValue.data(WebSocketState(
            channel: null,
            isConnected: false,
            isError: false,
            errorMessage: '',
          ));
          ref.read(navigationProvider.notifier).pushWebSocketClosedDialogScreen();
        },
        cancelOnError: false,
      );

      channel.sink.add(jsonEncode({
        'action': 'connect',
        'gameId': gameId,
        'userUniqueId': ref.read(userUniqueIdProvider),
        }));
      state = AsyncValue.data(WebSocketState(
        channel: channel,
        isConnected: true,
        isError: false,
        errorMessage: '',
      ));
      debugPrint('✅ WebSocket connected successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ WebSocket connection error: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> disconnect() async {
    debugPrint('❌ WebSocket disconnect');

    // Отменяем подписку
    await _subscription?.cancel();
    _subscription = null;

    // Закрываем канал
    try {
      await _currentChannel?.sink.close();
    } catch (e) {
      debugPrint('⚠️ Ошибка при закрытии WebSocket канала: $e');
    }
    _currentChannel = null;

    state = AsyncValue.data(WebSocketState(
      channel: null,
      isConnected: false,
      isError: false,
      errorMessage: '',
    ));

    debugPrint('✅ WebSocket disconnected');
  }
}

final webSocketNotifierProvider = AsyncNotifierProvider<WebSocketNotifier, WebSocketState>(() {
  return WebSocketNotifier();
});