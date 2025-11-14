import '../datasources/local/statistics_datasource.dart';
import 'package:seabattle/core/result.dart';
import 'package:seabattle/core/storage/storage_models.dart';

class StatisticsRepository {
  final StatisticsLocalDataSource statisticsLocalDataSource;

  StatisticsRepository({
    required this.statisticsLocalDataSource,
  });

  RequestOperation<void> saveStatistics(StatisticsModel statistics) async {
    try {
      await statisticsLocalDataSource.saveStatistics(statistics);
      return Result.ok(null);
    } catch (e) {
      throw Exception('Failed to save statistics: $e');
    }
  }

  RequestOperation<StatisticsModel?> getStatistics() async {
    try {
      return Result.ok(await statisticsLocalDataSource.getStatistics());
    } catch (e) {
      throw Exception('Failed to get statistics: $e');
    }
  }
}
