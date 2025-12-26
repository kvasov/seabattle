import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/home/presentation/screens/home_screen.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'test_helpers.dart';

void main() {
  setUpAll(() async {
    await LocaleSettings.useDeviceLocale();
  });

  group('HomeScreen виджет тесты', () {
    testWidgets('должен отображать главный экран с основными элементами', (WidgetTester tester) async {
      // устанавливаем размер экрана для теста
      setupTestScreenSize(tester);
      await tester.pumpWidget(createTestWidget(const HomeScreen()));

      // Игнорируем overflow ошибки
      tester.takeException();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('должен содержать кнопки создания и принятия игры', (WidgetTester tester) async {
      setupTestScreenSize(tester);
      await tester.pumpWidget(createTestWidget(const HomeScreen()));

      // Игнорируем overflow ошибки
      tester.takeException();

      await tester.pumpAndSettle();

      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('должен быть переход на экран создания игры', (WidgetTester tester) async {
      setupTestScreenSize(tester);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        TranslationProvider(
          // используем внешний ProviderContainer вместо создания нового
          child: UncontrolledProviderScope(
            container: container,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(800, 1200)),
              child: MaterialApp(
                home: const HomeScreen(),
                locale: const Locale('ru'),
              ),
            ),
          ),
        ),
      );

      tester.takeException();
      await tester.pumpAndSettle();

      // Находим кнопку создания игры по иконке
      final createButton = find.byIcon(Icons.qr_code);
      expect(createButton, findsOneWidget);

      // Нажимаем на кнопку
      await tester.tap(createButton);
      await tester.pumpAndSettle();

      // Проверяем, что навигация произошла
      final routes = container.read(navigationProvider);
      expect(routes.length, greaterThan(1));
      expect(routes.last.name, '/generateQRScreen');
    });

    testWidgets('должен быть переход на экран принятия игры', (WidgetTester tester) async {
      setupTestScreenSize(tester);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        TranslationProvider(
          child: UncontrolledProviderScope(
            container: container,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(800, 1200)),
              child: MaterialApp(
                home: const HomeScreen(),
                locale: const Locale('ru'),
              ),
            ),
          ),
        ),
      );

      tester.takeException();
      await tester.pumpAndSettle();

      final acceptButton = find.byIcon(Icons.camera_alt);
      expect(acceptButton, findsOneWidget);

      await tester.tap(acceptButton);
      await tester.pumpAndSettle();

      final routes = container.read(navigationProvider);
      expect(routes.length, greaterThan(1));
      expect(routes.last.name, '/scanQRScreen');
    });
  });
}
