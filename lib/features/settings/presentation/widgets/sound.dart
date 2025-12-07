import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/settings/providers/settings_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class SoundWidget extends ConsumerWidget {
  const SoundWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    final settingsAsync = ref.watch(settingsViewModelProvider);
    final settingsNotifier = ref.read(settingsViewModelProvider.notifier);

    final isSoundEnabled = settingsAsync.value?.settings?.isSoundEnabled ?? false;

    return SwitchListTile(
      title: Text(t.settings.sound),
      value: isSoundEnabled,
      onChanged: (v) {
        final currentSettings = settingsAsync.value?.settings;
        if (currentSettings != null) {
          settingsNotifier.saveSettings(currentSettings.copyWith(isSoundEnabled: v));
        }
      },
    );
  }
}