import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:flutter_test/flutter_test.dart';

// Создание тестового виджета с провайдерами
Widget createTestWidget(Widget child) {
  return TranslationProvider(
    child: ProviderScope(
      child: MediaQuery(
        data: const MediaQueryData(size: Size(800, 1200)),
        child: MaterialApp(
          home: child,
          locale: const Locale('ru'),
        ),
      ),
    ),
  );
}

// Настройка размера экрана
void setupTestScreenSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(2000, 3000);
  tester.view.devicePixelRatio = 1.0;
}
