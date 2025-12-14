import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/core/router/app_router_model.dart';

void main() {
  group('NavigationNotifier тесты', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('pushRoute должен добавлять маршрут в стек', () {
      final notifier = container.read(navigationProvider.notifier);
      final homeRoute = AppRoute.homeScreen();

      notifier.pushRoute(homeRoute);

      final state = container.read(navigationProvider);
      expect(state.length, 2);
      expect(state.last.name, '/homeScreen');
    });

    test('popRoute должен удалять последний маршрут из стека', () {
      final notifier = container.read(navigationProvider.notifier);
      notifier.pushRoute(AppRoute.homeScreen());
      notifier.pushRoute(AppRoute.settings());

      expect(container.read(navigationProvider).length, 3);

      notifier.popRoute();

      final state = container.read(navigationProvider);
      expect(state.length, 2);
      expect(state.last.name, '/homeScreen');
    });

    test('popRoute не должен удалять маршрут если в стеке только один элемент', () {
      final notifier = container.read(navigationProvider.notifier);

      expect(container.read(navigationProvider).length, 1);

      notifier.popRoute();

      expect(container.read(navigationProvider).length, 1);
    });

    test('replaceRoute должен заменять последний маршрут', () {
      final notifier = container.read(navigationProvider.notifier);
      notifier.pushRoute(AppRoute.homeScreen());

      notifier.replaceRoute(AppRoute.settings());

      final state = container.read(navigationProvider);
      expect(state.length, 2);
      expect(state.last.name, '/settings');
    });
  });
}
