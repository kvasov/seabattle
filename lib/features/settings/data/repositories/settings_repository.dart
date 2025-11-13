import '../datasources/local/settings_datasource.dart';
import 'package:seabattle/core/result.dart';
import 'package:seabattle/core/storage/storage_models.dart';

class SettingsRepository {
  final SettingsLocalDataSource settingsLocalDataSource;

  SettingsRepository({
    required this.settingsLocalDataSource,
  });

  RequestOperation<void> saveSettings(SettingsModel settings) async {
    try {
      await settingsLocalDataSource.saveSettings(settings);
      return Result.ok(null);
    } catch (e) {
      throw Exception('Failed to save settings: $e');
    }
  }

  RequestOperation<SettingsModel?> getSettings() async {
    try {
      return Result.ok(await settingsLocalDataSource.getSettings());
    } catch (e) {
      throw Exception('Failed to get settings: $e');
    }
  }
}
