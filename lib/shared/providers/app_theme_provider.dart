import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/core/storage/storage_models.dart';
import 'package:seabattle/features/settings/providers/settings_provider.dart';

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
  AppThemeState build() {
    // Используем watch() чтобы гарантировать инициализацию AsyncNotifier
    final settingsAsync = ref.watch(settingsViewModelProvider);
    final currentSettings = settingsAsync.value?.settings;

    return AppThemeState(
      themeMode: currentSettings?.themeMode ?? ThemeMode.system,
      seedColor: currentSettings?.seedColor ?? Color(currentSettings?.seedColorValue ?? 0),
    );
  }

  void setThemeMode(ThemeMode mode) {
    // Сначала обновляем локальное состояние для перерисовки UI
    state = state.copyWith(themeMode: mode);

    // Затем сохраняем в хранилище
    final settingsAsync = ref.read(settingsViewModelProvider);
    final currentSettings = settingsAsync.value?.settings;

    if (currentSettings != null) {
      ref.read(settingsViewModelProvider.notifier).saveSettings(
        currentSettings.copyWith(
          themeModeIndex: currentSettings.convertThemeModeToInt(mode),
        ),
      );
    } else {
      debugPrint('⚠️ setThemeMode: currentSettings == null, настройки еще не загружены');
    }
  }

  void toggleDark(bool isDark) => setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);

  void setSeedColor(Color color) {
    state = state.copyWith(seedColor: color);
    final settingsAsync = ref.read(settingsViewModelProvider);
    final currentSettings = settingsAsync.value?.settings;
    if (currentSettings != null) {
      ref.read(settingsViewModelProvider.notifier).saveSettings(
        currentSettings.copyWith(seedColorValue: SettingsModel.colorToInt(color)),
      );
    }
  }
}

final appThemeProvider = NotifierProvider<AppThemeNotifier, AppThemeState>(() {
  return AppThemeNotifier();
});


