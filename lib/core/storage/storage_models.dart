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

  SettingsModel({
    required this.language,
    required this.isSoundEnabled,
    required this.isAnimationsEnabled,
    required this.isVibrationEnabled,
    required this.themeModeIndex,
    required this.seedColorValue,
  });

  static int colorToInt(Color color) {
    final a = (color.a * 255.0).round() & 0xff;
    final r = (color.r * 255.0).round() & 0xff;
    final g = (color.g * 255.0).round() & 0xff;
    final b = (color.b * 255.0).round() & 0xff;
    return (a << 24) | (r << 16) | (g << 8) | b;
  }

  Color get seedColor => Color(seedColorValue);

  SettingsModel copyWith({
    String? language,
    bool? isSoundEnabled,
    bool? isAnimationsEnabled,
    bool? isVibrationEnabled,
    int? themeModeIndex,
    int? seedColorValue,
  }) {
    return SettingsModel(
      language: language ?? this.language,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      isAnimationsEnabled: isAnimationsEnabled ?? this.isAnimationsEnabled,
      isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
      themeModeIndex: themeModeIndex ?? this.themeModeIndex,
      seedColorValue: seedColorValue ?? this.seedColorValue,
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
class StatisticsModel {
  @HiveField(0)
  final int totalGames;

  @HiveField(1)
  final int totalWins;

  @HiveField(2)
  final int totalHits;

  @HiveField(3)
  final int totalShots;

  @HiveField(4)
  final int totalCancelled;

  StatisticsModel({
    required this.totalGames,
    required this.totalWins,
    required this.totalHits,
    required this.totalShots,
    required this.totalCancelled,
  });

  StatisticsModel copyWith({
    int? totalGames,
    int? totalWins,
    int? totalHits,
    int? totalShots,
    int? totalCancelled,
  }) {
    return StatisticsModel(
      totalGames: totalGames ?? this.totalGames,
      totalWins: totalWins ?? this.totalWins,
      totalHits: totalHits ?? this.totalHits,
      totalShots: totalShots ?? this.totalShots,
      totalCancelled: totalCancelled ?? this.totalCancelled,
    );
  }
}