import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/settings/presentation/viewmodels/settings_viewmodel.dart';

final settingsViewModelProvider = AsyncNotifierProvider<SettingsViewModelNotifier, SettingsViewModelState>(() {
  return SettingsViewModelNotifier();
});