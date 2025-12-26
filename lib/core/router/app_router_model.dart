import 'package:equatable/equatable.dart';

/// Модель маршрута.
///
/// Представляет маршрут с именем и опциональными аргументами.
class AppRoute extends Equatable {
  /// Имя маршрута.
  final String name;

  /// Аргументы маршрута.
  final Map<String, dynamic>? arguments;

  /// Создает маршрут.
  ///
  /// [name] - имя маршрута.
  /// [arguments] - опциональные аргументы маршрута.
  const AppRoute({
    required this.name,
    this.arguments,
  });

  /// Создает маршрут для splash экрана.
  factory AppRoute.splash() {
    return const AppRoute(name: '/splash');
  }

  /// Создает маршрут для главного экрана.
  factory AppRoute.homeScreen() {
    return const AppRoute(name: '/homeScreen');
  }

  /// Создает маршрут для экрана настроек.
  factory AppRoute.settings() {
    return const AppRoute(name: '/settings');
  }

  /// Создает маршрут для экрана генерации QR-кода.
  factory AppRoute.generateQRScreen() {
    return const AppRoute(name: '/generateQRScreen');
  }

  /// Создает маршрут для экрана сканирования QR-кода.
  factory AppRoute.scanQRScreen() {
    return const AppRoute(name: '/scanQRScreen');
  }

  /// Создает маршрут для экрана расстановки кораблей.
  factory AppRoute.setupShipsScreen() {
    return const AppRoute(name: '/setupShipsScreen');
  }

  /// Создает маршрут для диалогового окна.
  ///
  /// [arguments] - аргументы диалога.
  factory AppRoute.dialog({Map<String, dynamic>? arguments}) {
    return AppRoute(name: '/dialog', arguments: arguments);
  }

  /// Создает маршрут для экрана битвы.
  factory AppRoute.battleScreen() {
    return const AppRoute(name: '/battleScreen');
  }

  /// Создает маршрут для экрана статистики.
  factory AppRoute.statisticsScreen() {
    return const AppRoute(name: '/statisticsScreen');
  }

  /// Создает маршрут для диалога закрытия WebSocket соединения.
  factory AppRoute.webSocketClosedDialog() {
    return const AppRoute(name: '/webSocketClosedDialog');
  }

  @override
  List<Object?> get props => [name, arguments];
}
