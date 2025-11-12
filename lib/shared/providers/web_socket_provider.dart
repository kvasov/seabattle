import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:convert';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/shared/providers/user_provider.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';

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
      final channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:8888/ws'));
      _currentChannel = channel;

      // Сохраняем подписку для возможности отмены
      _subscription = channel.stream.listen(
        (data) {
          // debugPrint('☎️ WebSocket raw data: $data');
          try {
            final decoded = json.decode(data);
            // debugPrint('☎️ WebSocket decoded: $decoded');
            if (decoded['mode'] == 'accepted') {
              ref.read(navigationProvider.notifier).pushSetupShipsScreen();
            }
            if (decoded['mode'] == 'cancelled') {
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
                final opponentShips = shipsRaw
                    .map((ship) => Ship.fromJson(Map<String, dynamic>.from(ship as Map<String, dynamic>)))
                    .toList();

                final gameNotifier = ref.read(gameNotifierProvider.notifier);
                final gameState = gameNotifier.state.value;
                if (gameState != null) {
                  ref.read(battleViewModelProvider.notifier).setShips(
                    mode: 'opponent',
                    ships: opponentShips
                  );
                  gameNotifier.setOpponentReady();

                  // debugPrint('💚 opponentShips: $opponentShips');
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
                debugPrint('💚 Получен выстрел соперника на клетку ($shotX, $shotY)');

                final battleViewModelNotifier = ref.read(battleViewModelProvider.notifier);
                battleViewModelNotifier.addOpponentShot(shotX, shotY);
                if (decoded['isHit'] == true) {
                  battleViewModelNotifier.setMyMove(false);
                  if (battleViewModelNotifier.allShipsDead()) {
                    debugPrint('☠️ LOSE!');
                    ref.read(navigationProvider.notifier).pushLoseModal();
                    // TODO: обновить статистику в HIVE
                    // ref.read(gameNotifierProvider.notifier).setGameResult(GameResult.lose);
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
          // Обновляем состояние при ошибке
          state = AsyncValue.data(WebSocketState(
            channel: null,
            isConnected: false,
            isError: true,
            errorMessage: error.toString(),
          ));
        },
        onDone: () {
          debugPrint('🔌 WebSocket closed: ${channel.closeReason}');
          // Обновляем состояние при закрытии
          state = AsyncValue.data(WebSocketState(
            channel: null,
            isConnected: false,
            isError: false,
            errorMessage: '',
          ));
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

    // Отменяем подписку на stream
    await _subscription?.cancel();
    _subscription = null;

    // Закрываем канал
    try {
      await _currentChannel?.sink.close();
    } catch (e) {
      debugPrint('⚠️ Ошибка при закрытии WebSocket канала: $e');
    }
    _currentChannel = null;

    // Обновляем состояние
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