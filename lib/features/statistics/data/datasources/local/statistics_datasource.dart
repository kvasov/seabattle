import 'package:seabattle/core/storage/hive_storage.dart';
import 'package:seabattle/core/storage/storage_models.dart';

abstract class StatisticsLocalDataSource {
  Future<StatisticsModel?> getStatistics();
  Future<void> saveStatistics(StatisticsModel statistics);
}

class StatisticsLocalDataSourceImpl implements StatisticsLocalDataSource {
  StatisticsLocalDataSourceImpl();

  @override
  Future<void> saveStatistics(StatisticsModel statistics) async {
    try {
      await HiveStorage.statisticsBox.put(0, statistics);
    } catch (e) {
      throw Exception('❌ Failed to save statistics to local storage: $e');
    }
  }

  @override
  Future<StatisticsModel?> getStatistics() async {
    try {
      return HiveStorage.statisticsBox.get(0);
    } catch (e) {
      throw Exception('❌ Failed to get statistics from local storage: $e');
    }
  }
}
