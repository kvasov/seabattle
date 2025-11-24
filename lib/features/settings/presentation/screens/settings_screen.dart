import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/settings/presentation/widgets/ble.dart';
import 'package:seabattle/features/settings/presentation/widgets/accelerometer.dart';
import 'package:seabattle/features/settings/presentation/widgets/color_scheme.dart';
import 'package:seabattle/features/settings/presentation/widgets/vibration.dart';
import 'package:seabattle/features/settings/presentation/widgets/locale.dart';
import 'package:seabattle/features/settings/presentation/widgets/theme.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.etc.bottomNavigationBar.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ThemeWidget(),
          const SizedBox(height: 12),
          const LocaleWidget(),
          const SizedBox(height: 12),
          const ColorSchemeWidget(),
          Card(
            child: TextButton(onPressed: () {
              ref.read(navigationProvider.notifier).pushStatisticsScreen();
            }, child: Text('Перейти к статистике')),
          ),
          const BLEWidget(),
          const SizedBox(height: 12),
          const AccelerometerBallWidget(),
          const SizedBox(height: 12),
          const VibrationWidget(),
        ],
      ),
    );
  }
}
