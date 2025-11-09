import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppThemeState {
  const AppThemeState({
    required this.themeMode,
    required this.seedColor,
  });

  final ThemeMode themeMode;
  final Color seedColor;

  AppThemeState copyWith({ThemeMode? themeMode, Color? seedColor}) {
    return AppThemeState(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
    );
  }
}

class AppThemeNotifier extends Notifier<AppThemeState> {
  @override
  AppThemeState build() => const AppThemeState(themeMode: ThemeMode.system, seedColor: Colors.teal);

  void setThemeMode(ThemeMode mode) => state = state.copyWith(themeMode: mode);
  void toggleDark(bool isDark) => setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  void setSeedColor(Color color) => state = state.copyWith(seedColor: color);
}

final appThemeProvider = NotifierProvider<AppThemeNotifier, AppThemeState>(() {
  return AppThemeNotifier();
});


