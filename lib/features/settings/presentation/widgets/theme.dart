import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/app_theme_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class ThemeWidget extends ConsumerWidget {
  const ThemeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    final state = ref.watch(appThemeProvider);
    final controller = ref.read(appThemeProvider.notifier);
    final isDark = state.themeMode == ThemeMode.dark;

    return Card(
      child: SwitchListTile(
        title: Text(t.settings.darkTheme),
        subtitle: Text(isDark ? 'Включена' : 'Выключена'),
        value: isDark,
        onChanged: (v) => controller.toggleDark(v),
        secondary: const Icon(Icons.dark_mode_outlined),
      ),
    );
  }
}