import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/settings/providers/settings_provider.dart';

class VibrationWidget extends ConsumerWidget {
  const VibrationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsViewModelProvider);
    final settingsNotifier = ref.read(settingsViewModelProvider.notifier);

    final isVibrationEnabled = settingsAsync.value?.settings?.isVibrationEnabled ?? false;

    return SwitchListTile(
      title: const Text('Vibration'),
      value: isVibrationEnabled,
      onChanged: (v) {
        final currentSettings = settingsAsync.value?.settings;
        if (currentSettings != null) {
          settingsNotifier.saveSettings(currentSettings.copyWith(isVibrationEnabled: v));
        }
      },
    );
  }
}