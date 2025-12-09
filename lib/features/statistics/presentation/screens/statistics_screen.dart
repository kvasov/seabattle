import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/features/statistics/presentation/widgets/games_pie_widget.dart';
import 'package:seabattle/features/statistics/presentation/widgets/parts/hits_shots_widget.dart';
import 'package:seabattle/features/statistics/presentation/widgets/reset_btn.dart';
import 'package:seabattle/features/statistics/providers/statistics_provider.dart';
import 'package:seabattle/shared/providers/game_provider.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    final statistics = ref.watch(statisticsViewModelProvider);
    var totalGames = statistics.value?.statistics?.totalGames ?? 0;
    if (ref.read(gameNotifierProvider).value?.game != null) {
      totalGames--;
    }
    final totalWins = statistics.value?.statistics?.totalWins ?? 0;
    final totalCancelled = statistics.value?.statistics?.totalCancelled ?? 0;
    final totalLosses = totalGames - totalWins - totalCancelled;

    debugPrint('statistics: totalGames: $totalGames, totalWins: $totalWins, totalCancelled: $totalCancelled, totalLosses: $totalLosses');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
        title: Text(t.statistics.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (totalGames > 0) ...[
                  GamesPieWidget(
                    totalGames: totalGames,
                    totalWins: totalWins,
                    totalLosses: totalLosses,
                    totalCancelled: totalCancelled,
                  ),
                  SizedBox(height: 20),
                  HitsShotsWidget(),
                  SizedBox(height: 20),
                  ResetStatisticsButton(),
                ] else
                  Center(child: Text(t.statistics.noGamesPlayedYet)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}