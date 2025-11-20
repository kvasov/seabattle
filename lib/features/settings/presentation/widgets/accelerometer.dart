import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/accelerometer_provider.dart';

class AccelerometerBallWidget extends ConsumerWidget {
  const AccelerometerBallWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: Text('Accelerometer Ball'),
      value: ref.watch(accelerometerNotifierProvider).value?.isReceivingData ?? false,
      onChanged: (value) {
        ref.read(accelerometerNotifierProvider.notifier).toggleReceivingData();
      },
    );
  }
}