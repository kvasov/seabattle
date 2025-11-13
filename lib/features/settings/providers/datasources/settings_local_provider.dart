import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/settings/data/datasources/local/settings_datasource.dart';

final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  return SettingsLocalDataSourceImpl();
});