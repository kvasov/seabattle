import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/core/router/app_router_model.dart';

class NavigationNotifier extends Notifier<List<AppRoute>> {
  @override
  List<AppRoute> build() => [AppRoute.splash()];

  void pushRoute(AppRoute route) {
    state = [...state, route];
  }

  void popRoute() {
    if (state.length > 1) {
      state = state.sublist(0, state.length - 1);
    } else {
      debugPrint('🔙 popRoute: стек содержит только один элемент, pop не выполнен');
    }
  }

  void goToHome() {
    state = [AppRoute.splash()];
  }

  void replaceRoute(AppRoute route) {
    if (state.isNotEmpty) {
      final newStack = state.sublist(0, state.length - 1);
      state = [...newStack, route];
    } else {
      state = [route];
    }
  }

  void popUntilRoute(AppRoute route) {
    final index = state.lastIndexOf(route);
    if (index != -1) {
      state = state.sublist(0, index + 1);
    }
  }

  void replaceStack(List<AppRoute> newStack) {
    state = List.from(newStack);
  }

  void pushSettingsScreen() {
    pushRoute(AppRoute.settings());
  }

  void goToHomeScreen() {
    state = [AppRoute.homeScreen()];
  }

  void pushCreateGameScreen() {
    pushRoute(AppRoute.generateQRScreen());
  }

  void pushScanQRScreen() {
    pushRoute(AppRoute.scanQRScreen());
  }

  void goToSetupShipsScreen() {
    state = [AppRoute.setupShipsScreen()];
  }

  void pushCancelGameDialogScreen() {
    pushRoute(AppRoute.dialog(
      arguments: {
        'type': 'cancelGame',
      },
    ));
  }

  void pushCanceledGameDialogScreen() {
    pushRoute(AppRoute.dialog(
      arguments: {
        'type': 'canceledGame',
      },
    ));
  }

  void pushAcceptedGameDialogScreen() {
    pushRoute(AppRoute.dialog(
      arguments: {
        'type': 'acceptedGame',
      },
    ));
  }

  void pushLoseModal() {
    pushRoute(AppRoute.dialog(arguments: {'type': 'loseModal'}));
  }

  void pushWinModal() {
    pushRoute(AppRoute.dialog(arguments: {'type': 'winModal'}));
  }

  void pushBattleScreen() {
    pushRoute(AppRoute.battleScreen());
  }

  void pushStatisticsScreen() {
    pushRoute(AppRoute.statisticsScreen());
  }

  void pushWebSocketClosedDialogScreen() {
    pushRoute(AppRoute.dialog(arguments: {'type': 'webSocketClosedDialog'}));
  }
}

final navigationProvider = NotifierProvider<NavigationNotifier, List<AppRoute>>(() {
  return NavigationNotifier();
});

