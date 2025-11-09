import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/battle/presentation/viewmodels/battle_viewmodel.dart';

final battleViewModelProvider = AsyncNotifierProvider<BattleViewModelNotifier, BattleViewModelState>(() {
  return BattleViewModelNotifier();
});