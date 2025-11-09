import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('ru');

  void toggleLanguage() {
    state = state.languageCode == 'ru'
      ? const Locale('en')
      : const Locale('ru');

    final newLocale = state.languageCode == 'ru' ? AppLocale.ru : AppLocale.en;
    LocaleSettings.setLocaleSync(newLocale);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

