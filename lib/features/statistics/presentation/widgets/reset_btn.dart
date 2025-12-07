import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/features/statistics/providers/statistics_provider.dart';

class ResetStatisticsButton extends ConsumerWidget {
  const ResetStatisticsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    final statisticsViewModelNotifier = ref.read(statisticsViewModelProvider.notifier);

    return ElevatedButton(
      onPressed: () {
        statisticsViewModelNotifier.clearStatistics();
      },
      child: Text(t.statistics.resetStatistics),
    );
  }
}