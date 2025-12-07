import 'package:flutter/material.dart';
import 'package:seabattle/core/router/app_router_model.dart';

class AppRouteInformationParser extends RouteInformationParser<List<AppRoute>> {

  // URL -> stack
  @override
  Future<List<AppRoute>> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = routeInformation.uri;
    if (uri.pathSegments.isEmpty) {
      return [AppRoute.splash()];
    }

    // Односегментные пути - главный экран + целевой экран
    if (uri.pathSegments.length == 1) {
      final path = uri.pathSegments[0];

      if (path == 'settings') {
        return [AppRoute.settings()];
      }
      if (path == 'homeScreen') {
        return [AppRoute.homeScreen()];
      }
      if (path == 'generateQRScreen') {
        return [AppRoute.generateQRScreen()];
      }
      if (path == 'scanQRScreen') {
        return [AppRoute.scanQRScreen()];
      }
      if (path == 'statisticsScreen') {
        return [AppRoute.statisticsScreen()];
      }
    }

    // Неизвестный путь
    return [AppRoute.homeScreen()];
  }

  // stack -> URL
  @override
  RouteInformation restoreRouteInformation(List<AppRoute> configuration) {
    // Пустой стек или только главный экран - корневой путь
    debugPrint('🏁 configuration: $configuration');
    if (configuration.isEmpty || configuration.last.name == AppRoute.homeScreen().name) {
      return RouteInformation(uri: Uri.parse('/'));
    }

    // Возвращаем URL для последнего экрана в стеке
    final lastRoute = configuration.last;
    switch (lastRoute.name) {
      case '/splash':
        return RouteInformation(uri: Uri.parse('/splash'));
      case '/settings':
        return RouteInformation(uri: Uri.parse('/settings'));
      case '/homeScreen':
        return RouteInformation(uri: Uri.parse('/homeScreen'));
      case '/generateQRScreen':
        return RouteInformation(uri: Uri.parse('/generateQRScreen'));
      case '/scanQRScreen':
        return RouteInformation(uri: Uri.parse('/scanQRScreen'));
      case '/setupShipsScreen':
        return RouteInformation(uri: Uri.parse('/setupShipsScreen'));
      case '/battleScreen':
        return RouteInformation(uri: Uri.parse('/battleScreen'));
      case '/loseModal':
        return RouteInformation(uri: Uri.parse('/loseModal'));
      case '/winModal':
        return RouteInformation(uri: Uri.parse('/winModal'));
      case '/statisticsScreen':
        return RouteInformation(uri: Uri.parse('/statisticsScreen'));
      default:
        return RouteInformation(uri: Uri.parse('/'));
    }
  }
}

