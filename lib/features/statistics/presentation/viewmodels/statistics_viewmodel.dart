import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:seabattle/core/storage/storage_models.dart';
import 'package:seabattle/features/statistics/providers/repositories/statistics_repository_provider.dart';

class StatisticsViewModelState {
  final StatisticsModel? statistics;

  StatisticsViewModelState({this.statistics});
}

class StatisticsViewModelNotifier extends AsyncNotifier<StatisticsViewModelState> {

  @override
  Future<StatisticsViewModelState> build() async {
    try {
      final statisticsOperation = await ref.read(statisticsRepositoryProvider).getStatistics();
      StatisticsModel? statistics = statisticsOperation.data;
      if (statistics == null) {
        // statistics == null, создаем новую статистику
        statistics = StatisticsModel(
          totalGames: 0,
          totalWins: 0,
          totalHits: 0,
          totalShots: 0,
          totalCancelled: 0,
        );
        await ref.read(statisticsRepositoryProvider).saveStatistics(statistics);
      }

      return StatisticsViewModelState(statistics: statistics);

    } catch (e, stackTrace) {
      debugPrint('❌ StatisticsViewModelNotifier::build: ОШИБКА при получении statistics: $e');
      debugPrint('❌ StatisticsViewModelNotifier::build: StackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<void> incrementStatistic(String field) async {
    final currentState = state.value;
    if (currentState?.statistics == null) {
      return;
    }
    try {
      final currentStats = currentState!.statistics!;
      final updatedStatistics = switch (field) {
        'totalGames' => currentStats.copyWith(totalGames: currentStats.totalGames + 1),
        'totalWins' => currentStats.copyWith(totalWins: currentStats.totalWins + 1),
        'totalHits' => currentStats.copyWith(totalHits: currentStats.totalHits + 1),
        'totalShots' => currentStats.copyWith(totalShots: currentStats.totalShots + 1),
        'totalCancelled' => currentStats.copyWith(totalCancelled: currentStats.totalCancelled + 1),
        _ => throw ArgumentError('Неизвестное поле статистики: $field'),
      };

      state = AsyncValue.data(
        StatisticsViewModelState(statistics: updatedStatistics)
      );
      await ref.read(statisticsRepositoryProvider).saveStatistics(updatedStatistics);
    } catch (e) {
      if (currentState != null) {
        state = AsyncValue.data(currentState);
      }
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getStatistics() async {
    state = AsyncValue.data(
      StatisticsViewModelState(
        statistics: (await ref.read(statisticsRepositoryProvider).getStatistics()).data),
    );
  }
}