import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
  });
}
