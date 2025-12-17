import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/features/statistics/presentation/widgets/parts/legend.dart';
import 'package:seabattle/features/statistics/presentation/widgets/parts/pie_chart_widget.dart';

class GamesPieWidget extends ConsumerWidget {
  const GamesPieWidget({
    super.key,
    required this.totalGames,
    required this.totalWins,
    required this.totalLosses,
    required this.totalCancelled,
  });

  final int totalGames;
  final int totalWins;
  final int totalLosses;
  final int totalCancelled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    final maxWidthPieChart = MediaQuery.of(context).size.width * 0.5;

    final colorLosses = Theme.of(context).colorScheme.error;
    final colorWins = Theme.of(context).colorScheme.primary;
    final colorCancelled = Theme.of(context).colorScheme.surfaceContainer;

    return Row(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
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
          crossAxisAlignment: .start,
          children: [
            Legend(title: t.statistics.losses, color: colorLosses),
            Legend(title: t.statistics.wins, color: colorWins),
            Legend(title: t.statistics.cancelled, color: colorCancelled),
            SizedBox(height: 10),
            Text('${t.statistics.totalGames} $totalGames'),
            Text('${t.statistics.totalWins} $totalWins'),
            Text('${t.statistics.totalLosses} $totalLosses'),
            Text('${t.statistics.totalCancelled} $totalCancelled'),
          ],
        ),
      ],
    );
  }
}