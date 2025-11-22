import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/features/settings/providers/settings_provider.dart';


class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final settingsAsync = ref.watch(settingsViewModelProvider);
    final currentSettings = settingsAsync.value?.settings;

    if (currentSettings != null) {
      final appLocale = currentSettings.language == 'ru' ? AppLocale.ru : AppLocale.en;
      LocaleSettings.setLocale(appLocale);
    }

    return Locale(currentSettings?.language ?? 'ru');
  }

  void toggleLanguage() {
    state = state.languageCode == 'ru'
      ? const Locale('en')
      : const Locale('ru');

    final newLocale = state.languageCode == 'ru' ? AppLocale.ru : AppLocale.en;
    final settingsAsync = ref.read(settingsViewModelProvider);
    final currentSettings = settingsAsync.value?.settings;
    if (currentSettings != null) {
      ref.read(settingsViewModelProvider.notifier).saveSettings(currentSettings.copyWith(language: newLocale.languageCode));
    }
    LocaleSettings.setLocaleSync(newLocale);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

