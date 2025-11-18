import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/shared/providers/locale_provider.dart';

class LocaleWidget extends ConsumerWidget {
  const LocaleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final localeState = ref.watch(localeProvider);

    return Card(
      child: TextButton(
        onPressed: () {
          ref.read(localeProvider.notifier).toggleLanguage();
        },
        child: Text(localeState.languageCode == 'ru' ? t.etc.language.ru : t.etc.language.en),
      ),
    );
  }
}