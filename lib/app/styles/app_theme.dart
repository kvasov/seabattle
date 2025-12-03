import 'package:flutter/material.dart';
import 'package:seabattle/app/styles/theme_extension/switch.dart';
import 'package:seabattle/app/styles/theme_extension/simple_button.dart';
import 'package:seabattle/core/constants/colors.dart';

class AppTheme {
  const AppTheme();

  static ThemeData buildLightTheme(Color seedColor) {
    final scheme = ColorScheme.fromSeed(brightness: Brightness.light, seedColor: seedColor);
    // Кастомные цвета для Switch, доступные через Theme.of(context).extension<AppSwitchColors>()
    final switchExt = AppSwitchColors(
      thumbOn: Colors.white,
      thumbOff: Colors.black,
      trackOn: Colors.green,
      trackOff: Colors.red,
    );
    final buttonExt = ButtonColors(
      backgroundColor: Colors.white,
      textColor: lightBlue,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.light,
      extensions: <ThemeExtension<dynamic>>[
        switchExt,
        buttonExt,
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface, // цвет фона AppBar
        foregroundColor: scheme.onSurface, // цвет текста и иконок AppBar
        elevation: 0, // тень AppBar
        centerTitle: true, // выравнивание заголовка по центру (iOS-стиль)
      ),
      scaffoldBackgroundColor: scheme.surface, // фон основных экранов (Scaffold)
      switchTheme: SwitchThemeData(
        // Цвет «бегунка» переключателя (круглая часть)
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return switchExt.thumbOn; // при включенном состоянии
          return switchExt.thumbOff; // при выключенном состоянии
        }),
        // Цвет «дорожки» переключателя (продолговатая часть)
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return switchExt.trackOn; // при включенном состоянии
          return switchExt.trackOff; // при выключенном состоянии
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh, // фон чипов по умолчанию
        side: BorderSide(color: scheme.outlineVariant), // рамка чипов
        selectedColor: scheme.primaryContainer, // фон чипов в выбранном состоянии
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return scheme.primaryContainer; // фон выбранного сегмента
            return scheme.surfaceContainer; // фон невыбранного сегмента
          }),
          foregroundColor: WidgetStatePropertyAll(scheme.onSurface), // цвет текста/иконок сегментов
        ),
      ),
    );
  }

  static ThemeData buildDarkTheme(Color seedColor) {
    final scheme = ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: seedColor);

    final switchExt = AppSwitchColors(
      thumbOn: scheme.primary,
      thumbOff: scheme.surfaceContainer,
      trackOn: scheme.primaryContainer,
      trackOff: scheme.surfaceContainerHigh,
    );
    final buttonExt = ButtonColors(
      backgroundColor: darkBlue,
      textColor: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.dark,
      extensions: <ThemeExtension<dynamic>>[
        switchExt,
        buttonExt,
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      scaffoldBackgroundColor: scheme.background,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return switchExt.thumbOn;
          return switchExt.thumbOff;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return switchExt.trackOn;
          return switchExt.trackOff;
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        side: BorderSide(color: scheme.outlineVariant),
        selectedColor: scheme.primaryContainer,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return scheme.primaryContainer;
            return scheme.surfaceContainer;
          }),
          foregroundColor: WidgetStatePropertyAll(scheme.onSurface),
        ),
      ),
    );
  }
}


