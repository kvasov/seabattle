import 'package:equatable/equatable.dart';

class AppRoute extends Equatable {
  final String name;
  final Map<String, dynamic>? arguments;

  const AppRoute({
    required this.name,
    this.arguments,
  });

  factory AppRoute.splash() {
    return const AppRoute(name: '/splash');
  }

  factory AppRoute.homeScreen() {
    return const AppRoute(name: '/homeScreen');
  }

  factory AppRoute.settings() {
    return const AppRoute(name: '/settings');
  }

  factory AppRoute.generateQRScreen() {
    return const AppRoute(name: '/generateQRScreen');
  }

  factory AppRoute.scanQRScreen() {
    return const AppRoute(name: '/scanQRScreen');
  }

  factory AppRoute.setupShipsScreen() {
    return const AppRoute(name: '/setupShipsScreen');
  }

  factory AppRoute.dialog({Map<String, dynamic>? arguments}) {
    return AppRoute(name: '/dialog', arguments: arguments);
  }

  factory AppRoute.battleScreen() {
    return const AppRoute(name: '/battleScreen');
  }

  @override
  List<Object?> get props => [name, arguments];
}
