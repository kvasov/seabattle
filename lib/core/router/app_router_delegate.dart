import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/core/router/app_router_model.dart';
import 'package:seabattle/shared/custom_page.dart';
import 'package:seabattle/shared/presentation/widgets/dialog.dart';
import 'package:seabattle/shared/presentation/widgets/cancel_game_dialog.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/features/home/presentation/screens/home_screen.dart';
import 'package:seabattle/features/settings/presentation/screens/settings_screen.dart';
import 'package:seabattle/features/splash/screens/splash_screen.dart';
import 'package:seabattle/features/qr/presentation/screens/generate_screen.dart';
import 'package:seabattle/features/qr/presentation/screens/scan_screen.dart';
import 'package:seabattle/features/ships_setup/presentation/screens/setup_ships_screen.dart';
import 'package:seabattle/features/battle/presentation/screens/battle_screen.dart';
import 'package:seabattle/features/battle/presentation/widgets/modal/lose_modal.dart';
import 'package:seabattle/features/battle/presentation/widgets/modal/win_modal.dart';
import 'package:seabattle/features/statistics/presentation/screens/statistics_screen.dart';

/// Делегат роутера для управления навигацией в приложении.
///
/// Отвечает за создание страниц на основе маршрутов и управление стеком навигации.
class AppRouterDelegate extends RouterDelegate<List<AppRoute>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<AppRoute>> {

  /// Референс на провайдеры Riverpod.
  final WidgetRef ref;
  late final ProviderSubscription<List<AppRoute>> _subscription;

  /// Создает делегат роутера.
  ///
  /// [ref] - референс на провайдеры Riverpod.
  AppRouterDelegate(this.ref) {
    _subscription = ref.listenManual(
      navigationProvider,
      (previous, next) {
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  List<AppRoute> get currentConfiguration => ref.read(navigationProvider);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _buildPages(),
      onDidRemovePage: (page) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(navigationProvider.notifier).popRoute();
        });
      },
    );
  }

  /// Строит список страниц на основе текущей конфигурации маршрутов.
  List<Page> _buildPages() {
    return currentConfiguration.asMap().entries.map((entry) {
      final index = entry.key;
      final route = entry.value;
      return _createPage(route, index);
    }).toList();
  }

  /// Создает страницу на основе маршрута.
  ///
  /// [route] - маршрут для создания страницы.
  /// [index] - индекс маршрута в стеке.
  Page _createPage(AppRoute route, int index) {
    Widget screen;

    switch (route.name) {
      case '/splash':
        screen = const SplashScreen();
        break;

      case '/homeScreen':
        screen = const HomeScreen();
        break;

      case '/settings':
        screen = const SettingsScreen();
        break;

      case '/generateQRScreen':
        screen = const GenerateQRScreen();
        break;

      case '/scanQRScreen':
        screen = const ScanQRScreen();
        break;

      case '/setupShipsScreen':
        screen = const SetupShipsScreen();
        break;

      case '/dialog':
        final arguments = route.arguments ?? <String, dynamic>{};
        final dialogType = arguments['type'] as String?;
        Widget dialogChild;
        var barrierDismissible = true;

        switch (dialogType) {
          case 'cancelGame':
            dialogChild = const CancelGameDialog();
            break;
          case 'canceledGame':
            dialogChild = const CanceledGameDialog();
            break;
          case 'acceptedGame':
            dialogChild = const AcceptedGameDialog();
            break;
          case 'loseModal':
            dialogChild = const LoseModal();
            barrierDismissible = false;
            break;
          case 'winModal':
            dialogChild = const WinModal();
            barrierDismissible = false;
            break;
          case 'webSocketClosedDialog':
            dialogChild = const WebSocketClosedDialog();
            barrierDismissible = false;
            break;
          default:
            dialogChild = const AlertDialog(title: Text('Dialog'));
        }

        return DialogPage(
          key: ValueKey('${route.name}_$index'),
          child: dialogChild,
          barrierDismissible: barrierDismissible,
        );

      case '/battleScreen':
        screen = const BattleScreen();
        break;

      case '/statisticsScreen':
        screen = const StatisticsScreen();
        break;

      default:
        screen = const SizedBox.shrink();
        break;
    }

    return CustomPage(
      key: ValueKey('${route.name}_$index'),
      child: screen,
      name: route.name,
      arguments: route.arguments,
    );
  }

  @override
  Future<void> setNewRoutePath(List<AppRoute> configuration) async {
    final notifier = ref.read(navigationProvider.notifier);
    notifier.replaceStack(configuration);
  }
}