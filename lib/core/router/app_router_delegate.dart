import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/core/router/app_router_model.dart';
import 'package:seabattle/shared/custom_page.dart';
import 'package:seabattle/shared/widgets/dialog.dart';
import 'package:seabattle/shared/widgets/cancel_game_dialog.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/features/home/presentation/screens/home_screen.dart';
import 'package:seabattle/features/settings/presentation/screens/settings_screen.dart';
import 'package:seabattle/features/splash/screens/splash_screen.dart';
import 'package:seabattle/features/qr/presentation/screens/generate_screen.dart';
import 'package:seabattle/features/qr/presentation/screens/scan_screen.dart';
import 'package:seabattle/features/ships_setup/presentation/screens/setup_ships_screen.dart';
import 'package:seabattle/features/battle/presentation/screens/battle_screen.dart';

class AppRouterDelegate extends RouterDelegate<List<AppRoute>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<AppRoute>> {

  final WidgetRef ref;
  late final ProviderSubscription<List<AppRoute>> _subscription;

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

  List<Page> _buildPages() {
    return currentConfiguration.asMap().entries.map((entry) {
      final index = entry.key;
      final route = entry.value;
      return _createPage(route, index);
    }).toList();
  }

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
        print('☎️ dialogType: $dialogType');
        Widget dialogChild;

        switch (dialogType) {
          case 'cancelGame':
            dialogChild = const CancelGameDialog();
            break;
          case 'canceledGame':
            dialogChild = const CanceledGameDialog();
            break;
          default:
            dialogChild = const AlertDialog(title: Text('Dialog'));
        }

        return DialogPage(
          key: ValueKey('${route.name}_$index'),
          child: dialogChild,
        );

      case '/battleScreen':
        screen = const BattleScreen();
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