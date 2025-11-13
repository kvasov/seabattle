import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'storage_models.g.dart';

@HiveType(typeId: 0)
class SettingsModel {
  @HiveField(0)
  final String language;

  @HiveField(1)
  final bool isSoundEnabled;

  @HiveField(2)
  final bool isAnimationsEnabled;

  @HiveField(3)
  final bool isVibrationEnabled;

  @HiveField(4)
  final int themeModeIndex;
  // 0 - system, 1 - light, 2 - dark

  @HiveField(5)
  final int seedColorValue;
  // Значение цвета как int (Color.value)

  SettingsModel({
    required this.language,
    required this.isSoundEnabled,
    required this.isAnimationsEnabled,
    required this.isVibrationEnabled,
    required this.themeModeIndex,
    required Color seedColor,
  }) : seedColorValue = seedColor.value;

  // Геттер для получения Color из значения
  Color get seedColor => Color(seedColorValue);

  SettingsModel copyWith({
    String? language,
    bool? isSoundEnabled,
    bool? isAnimationsEnabled,
    bool? isVibrationEnabled,
    int? themeModeIndex,
    Color? seedColor,
  }) {
    return SettingsModel(
      language: language ?? this.language,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      isAnimationsEnabled: isAnimationsEnabled ?? this.isAnimationsEnabled,
      isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
      themeModeIndex: themeModeIndex ?? this.themeModeIndex,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  ThemeMode convertIntToThemeMode(int index) {
    switch (index) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        throw ThemeMode.light;
    }
  }

  int convertThemeModeToInt(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 0;
      case ThemeMode.light:
        return 1;
      case ThemeMode.dark:
        return 2;
    }
  }

  ThemeMode get themeMode => convertIntToThemeMode(themeModeIndex);
}

@HiveType(typeId: 1)
class Statistics {
  @HiveField(0)
  final int totalGames;

  @HiveField(1)
  final int totalWins;

  const Statistics({
    required this.totalGames,
    required this.totalWins,
  });
}