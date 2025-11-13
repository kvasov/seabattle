import 'package:seabattle/core/storage/hive_storage.dart';
import 'package:seabattle/core/storage/storage_models.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel?> getSettings();
  Future<void> saveSettings(SettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl();

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      await HiveStorage.settingsBox.put(0, settings);
    } catch (e) {
      throw Exception('❌ Failed to save settings to local storage: $e');
    }
  }

  @override
  Future<SettingsModel?> getSettings() async {
    try {
      return HiveStorage.settingsBox.get(0);
    } catch (e) {
      throw Exception('❌ Failed to get settings from local storage: $e');
    }
  }
}
