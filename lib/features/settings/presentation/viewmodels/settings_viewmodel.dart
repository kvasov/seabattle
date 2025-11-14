import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:seabattle/core/storage/storage_models.dart';
import 'package:seabattle/features/settings/providers/repositories/settings_repository_provider.dart';

class SettingsViewModelState {
  final SettingsModel? settings;

  SettingsViewModelState({this.settings});
}

class SettingsViewModelNotifier extends AsyncNotifier<SettingsViewModelState> {

  @override
  Future<SettingsViewModelState> build() async {
    try {
      final settingsOperation = await ref.read(settingsRepositoryProvider).getSettings();
      SettingsModel? settings = settingsOperation.data;
      if (settings == null) {
        debugPrint('🤍🧡🤍 build: settings == null, создаем новые настройки');
        settings = SettingsModel(
          language: 'ru',
          isSoundEnabled: true,
          isAnimationsEnabled: true,
          isVibrationEnabled: true,
          themeModeIndex: settings?.convertThemeModeToInt(ThemeMode.system) ?? 0,
          seedColorValue: SettingsModel.colorToInt(Colors.teal),
        );
        debugPrint('🤍🧡🤍 build: сохраняем новые настройки');
        await ref.read(settingsRepositoryProvider).saveSettings(settings);
      }

      return SettingsViewModelState(settings: settings);

    } catch (e, stackTrace) {
      debugPrint('🤍🧡🤍 build: ОШИБКА при получении settings: $e');
      debugPrint('🤍🧡🤍 build: StackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<void> saveSettings(SettingsModel settings) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(settingsRepositoryProvider).saveSettings(settings);
      state = AsyncValue.data(SettingsViewModelState(settings: settings));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Future<void> getSettings() async {
  //   state = AsyncValue.data(
  //     SettingsViewModelState(
  //       settings: await ref.read(settingsRepositoryProvider).getSettings()),
  //   );
  // }
}