import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/statistics/data/repositories/statistics_repository.dart';
import 'package:seabattle/features/statistics/providers/datasources/statistics_local_provider.dart';

final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  return StatisticsRepository(
    statisticsLocalDataSource: ref.watch(statisticsLocalDataSourceProvider),
  );
});