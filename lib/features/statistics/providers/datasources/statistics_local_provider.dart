import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/statistics/data/datasources/local/statistics_datasource.dart';

final statisticsLocalDataSourceProvider = Provider<StatisticsLocalDataSource>((ref) {
  return StatisticsLocalDataSourceImpl();
});