import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/core/router/app_router_model.dart';

/// Провайдер для управления навигацией в приложении.
///
/// Управляет стеком маршрутов и предоставляет методы для навигации.
class NavigationNotifier extends Notifier<List<AppRoute>> {
  @override
  List<AppRoute> build() => [AppRoute.splash()];

  /// Добавляет новый маршрут в стек навигации.
  ///
  /// [route] - маршрут для добавления.
  void pushRoute(AppRoute route) {
    state = [...state, route];
  }

  /// Удаляет последний маршрут из стека навигации.
  ///
  /// Не выполняет операцию, если в стеке только один элемент.
  void popRoute() {
    if (state.length > 1) {
      state = state.sublist(0, state.length - 1);
    } else {
      debugPrint('🔙 popRoute: стек содержит только один элемент, pop не выполнен');
    }
  }

  /// Переходит на начальный экран (splash).
  void goToHome() {
    state = [AppRoute.splash()];
  }

  /// Заменяет последний маршрут в стеке на новый.
  ///
  /// [route] - новый маршрут для замены.
  void replaceRoute(AppRoute route) {
    if (state.isNotEmpty) {
      final newStack = state.sublist(0, state.length - 1);
      state = [...newStack, route];
    } else {
      state = [route];
    }
  }

  /// Удаляет маршруты из стека до указанного маршрута включительно.
  ///
  /// [route] - маршрут, до которого нужно удалить элементы.
  void popUntilRoute(AppRoute route) {
    final index = state.lastIndexOf(route);
    if (index != -1) {
      state = state.sublist(0, index + 1);
    }
  }

  /// Заменяет весь стек навигации новым стеком.
  ///
  /// [newStack] - новый стек маршрутов.
  void replaceStack(List<AppRoute> newStack) {
    state = List.from(newStack);
  }

  /// Переходит на экран настроек.
  void pushSettingsScreen() {
    pushRoute(AppRoute.settings());
  }

  /// Переходит на главный экран.
  void goToHomeScreen() {
    state = [AppRoute.homeScreen()];
  }

  /// Переходит на экран создания игры (генерация QR-кода).
  void pushCreateGameScreen() {
    pushRoute(AppRoute.generateQRScreen());
  }

  /// Переходит на экран сканирования QR-кода.
  void pushScanQRScreen() {
    pushRoute(AppRoute.scanQRScreen());
  }

  /// Переходит на экран расстановки кораблей.
  void goToSetupShipsScreen() {
    state = [AppRoute.setupShipsScreen()];
  }

  /// Открывает диалог отмены игры.
  void pushCancelGameDialogScreen() {
    pushRoute(AppRoute.dialog(
      arguments: {
        'type': 'cancelGame',
      },
    ));
  }

  /// Открывает диалог отмененной игры.
  void pushCanceledGameDialogScreen() {
    pushRoute(AppRoute.dialog(
      arguments: {
        'type': 'canceledGame',
      },
    ));
  }

  /// Открывает диалог принятой игры.
  void pushAcceptedGameDialogScreen() {
    pushRoute(AppRoute.dialog(
      arguments: {
        'type': 'acceptedGame',
      },
    ));
  }

  /// Открывает модальное окно проигрыша.
  void pushLoseModal() {
    pushRoute(AppRoute.dialog(arguments: {'type': 'loseModal'}));
  }

  /// Открывает модальное окно победы.
  void pushWinModal() {
    pushRoute(AppRoute.dialog(arguments: {'type': 'winModal'}));
  }

  /// Переходит на экран битвы.
  void pushBattleScreen() {
    pushRoute(AppRoute.battleScreen());
  }

  /// Переходит на экран статистики.
  void pushStatisticsScreen() {
    pushRoute(AppRoute.statisticsScreen());
  }

  /// Открывает диалог закрытия WebSocket соединения.
  void pushWebSocketClosedDialogScreen() {
    pushRoute(AppRoute.dialog(arguments: {'type': 'webSocketClosedDialog'}));
  }
}

/// Провайдер для управления навигацией приложения.
final navigationProvider = NotifierProvider<NavigationNotifier, List<AppRoute>>(() {
  return NavigationNotifier();
});

