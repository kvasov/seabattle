import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/settings/providers/datasources/settings_local_provider.dart';
import 'package:seabattle/features/settings/data/repositories/settings_repository.dart';


final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(
    settingsLocalDataSource: ref.watch(settingsLocalDataSourceProvider),
  );
});