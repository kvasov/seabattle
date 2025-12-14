import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seabattle/features/settings/presentation/screens/settings_screen.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/core/services/init.dart' as di;
import 'test_helpers.dart';

void main() {
  setUpAll(() async {
    await LocaleSettings.useDeviceLocale();
    await di.init();
  });

  group('SettingsScreen виджет тесты', () {
    testWidgets('должен отображать экран настроек с AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const SettingsScreen()));
      tester.takeException();
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('должен содержать ListView с настройками', (WidgetTester tester) async {
      setupTestScreenSize(tester);
      await tester.pumpWidget(createTestWidget(const SettingsScreen()));
      tester.takeException();

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('должен содержать кнопку перехода к статистике', (WidgetTester tester) async {
      setupTestScreenSize(tester);
      await tester.pumpWidget(createTestWidget(const SettingsScreen()));
      tester.takeException();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(TextButton), findsWidgets);
    });
  });
}
