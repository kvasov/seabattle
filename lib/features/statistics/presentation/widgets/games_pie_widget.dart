import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/statistics/providers/statistics_provider.dart';
import 'package:seabattle/features/statistics/presentation/widgets/parts/legend.dart';
import 'package:seabattle/features/statistics/presentation/widgets/parts/pie_chart_widget.dart';

class GamesPieWidget extends ConsumerWidget {
  const GamesPieWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final maxWidthPieChart = MediaQuery.of(context).size.width * 0.5;

    final statistics = ref.watch(statisticsViewModelProvider);
    final totalGames = statistics.value?.statistics?.totalGames ?? 0;
    final totalWins = statistics.value?.statistics?.totalWins ?? 0;
    final totalLosses = totalGames - totalWins;
    final totalCancelled = statistics.value?.statistics?.totalCancelled ?? 0;

    final colorLosses = Theme.of(context).colorScheme.error;
    final colorWins = Theme.of(context).colorScheme.primary;
    final colorCancelled = Theme.of(context).colorScheme.surfaceContainer;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidthPieChart,
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChartWidget(
                maxWidth: maxWidthPieChart,
                totalGames: totalGames.toDouble(),
                totalWins: totalWins.toDouble(),
                totalLosses: totalLosses.toDouble(),
                totalCancelled: totalCancelled.toDouble(),
                colorLosses: colorLosses,
                colorWins: colorWins,
                colorCancelled: colorCancelled,
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Legend(title: 'Losses', color: colorLosses),
            Legend(title: 'Wins', color: colorWins),
            Legend(title: 'Cancelled', color: colorCancelled),
            SizedBox(height: 10),
            Text('Total Games $totalGames'),
            Text('Total Wins $totalWins'),
            Text('Total Losses $totalLosses'),
            Text('Total Cancelled $totalCancelled'),
          ],
        ),
      ],
    );
  }
}