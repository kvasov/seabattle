import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/statistics/presentation/viewmodels/statistics_viewmodel.dart';

final statisticsViewModelProvider = AsyncNotifierProvider<StatisticsViewModelNotifier, StatisticsViewModelState>(() {
  return StatisticsViewModelNotifier();
});