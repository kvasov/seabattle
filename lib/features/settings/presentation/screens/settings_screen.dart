import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/core/storage/hive_storage.dart';
import 'package:seabattle/features/settings/providers/settings_provider.dart';
import 'package:seabattle/shared/providers/app_theme_provider.dart';
import 'package:seabattle/shared/providers/locale_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final state = ref.watch(appThemeProvider);
    final controller = ref.read(appThemeProvider.notifier);
    final isDark = state.themeMode == ThemeMode.dark;

    final colors = <Color>[
      Colors.teal,
      Colors.blue,
      Colors.purple,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(t.etc.bottomNavigationBar.settings),
        actions: [
          IconButton(
            tooltip: 'Системная тема',
            icon: const Icon(Icons.settings_suggest_outlined),
            onPressed: () => controller.setThemeMode(ThemeMode.system),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Тёмная тема'),
              subtitle: Text(isDark ? 'Включена' : 'Выключена'),
              value: isDark,
              onChanged: (v) => controller.toggleDark(v),
              secondary: const Icon(Icons.dark_mode_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: TextButton(
              onPressed: () {
                ref.read(localeProvider.notifier).toggleLanguage();
              },
              child: Text(ref.read(localeProvider).languageCode == 'ru' ? t.etc.language.ru : t.etc.language.en),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Выбор цветовой схемы',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final color in colors)
                        _ColorChoice(
                          color: color,
                          selected: color == state.seedColor,
                          onTap: () => controller.setSeedColor(color),
                        ),
                    ],
                  ),
                  TextButton(onPressed: () {
                    HiveStorage.debugPrintBox(HiveStorage.settingsBoxName);
                  }, child: Text('Вывести все настройки из HiveStorage.settingsBoxName')),
                  TextButton(onPressed: () {
                    HiveStorage.clearBox(HiveStorage.settingsBoxName);
                  }, child: Text('Стереть все настройки из settingsBoxName')),
                  Text('language: ${ref.read(settingsViewModelProvider).value?.settings?.language}'),
                ],
              ),
            ),
          ),
          Card(
            child: TextButton(onPressed: () {
              ref.read(navigationProvider.notifier).pushStatisticsScreen();
            }, child: Text('Перейти к статистике')),
          ),
        ],
      ),
    );
  }
}

class _ColorChoice extends StatelessWidget {
  const _ColorChoice({required this.color, required this.selected, required this.onTap});

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: selected ? scheme.inverseSurface : scheme.outline, width: selected ? 3 : 1),
        ),
        child: selected
            ? const Icon(
                Icons.check,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
