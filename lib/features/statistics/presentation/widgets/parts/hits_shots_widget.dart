import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/statistics/providers/statistics_provider.dart';
import 'package:seabattle/features/statistics/presentation/widgets/parts/legend.dart';

class HitsShotsWidget extends ConsumerWidget {
  const HitsShotsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(statisticsViewModelProvider);
    final totalHits = statistics.value?.statistics?.totalHits ?? 0;
    final totalShots = statistics.value?.statistics?.totalShots ?? 0;

    // Вычисляем процент попаданий
    final hitsPercentage = totalShots > 0 ? (totalHits / totalShots) : 0.0;
    final missesPercentage = totalShots > 0 ? ((totalShots - totalHits) / totalShots) : 0.0;

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final hitsWidth = maxWidth * hitsPercentage;
            final missesWidth = maxWidth * missesPercentage;

            return Row(
              children: [
                if (hitsWidth > 0)
                  Container(
                    width: hitsWidth,
                    height: 20,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                if (missesWidth > 0)
                  Container(
                    width: missesWidth,
                    height: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              ],
            );
          },
        ),
        SizedBox(height: 8),
        Column(
          children: [
            Legend(
              title: 'Hits $totalHits',
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            SizedBox(width: 20),
            Legend(
              title: 'Misses ${totalShots - totalHits}',
              color: Theme.of(context).colorScheme.onSurface,
            ),
            SizedBox(width: 20),
            Legend(
              title: 'Accuracy ${totalShots > 0 ? ((totalHits / totalShots) * 100).toStringAsFixed(2) : '0.00'}%',
              color: Theme.of(context).colorScheme.surfaceDim),
          ],
        ),
      ],
    );
  }
}