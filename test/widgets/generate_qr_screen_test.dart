import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/qr/presentation/screens/generate_screen.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'test_helpers.dart';

void main() {
  setUpAll(() async {
    await LocaleSettings.useDeviceLocale();
  });

  group('GenerateQRScreen виджет тесты', () {
    testWidgets('должен отображать экран создания игры с AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const GenerateQRScreen()));
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('должен содержать кнопку назад', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const GenerateQRScreen()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('должен отображать Column для размещения элементов', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const GenerateQRScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('должен выполнять навигацию назад', (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        TranslationProvider(
          child: UncontrolledProviderScope(
            container: container,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(800, 1200)),
              child: MaterialApp(
                initialRoute: '/home',
                routes: {
                  '/home': (context) => const Scaffold(
                    body: Center(child: Text('Home')),
                  ),
                  '/generate': (context) => const GenerateQRScreen(),
                },
                locale: const Locale('ru'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Переходим на экран создания игры через Navigator
      final homeContext = tester.element(find.text('Home'));
      Navigator.of(homeContext).pushNamed('/generate');
      await tester.pumpAndSettle();

      // Проверяем, что мы на экране создания игры
      expect(find.byType(GenerateQRScreen), findsOneWidget);

      // Находим кнопку назад
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      // и нажимаем
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Проверяем, что вернулись на Home
      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(GenerateQRScreen), findsNothing);
    });
  });
}
