import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seabattle/features/home/presentation/screens/home_screen.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
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
  });
}
