import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/accelerometer_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class AccelerometerBallWidget extends ConsumerWidget {
  const AccelerometerBallWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    return SwitchListTile(
      title: Text(t.settings.accelerometerBall),
      value: ref.watch(accelerometerNotifierProvider).value?.isReceivingData ?? false,
      onChanged: (value) {
        ref.read(accelerometerNotifierProvider.notifier).toggleReceivingData();
      },
    );
  }
}