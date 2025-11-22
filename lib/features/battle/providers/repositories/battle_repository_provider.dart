import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/battle/data/repositories/battle_repository.dart';
import 'package:seabattle/features/battle/providers/datasources/battle_remote_provider.dart';
import 'package:seabattle/shared/providers/datasources/network_info_provider.dart';

final battleRepositoryProvider = Provider<BattleRepository>((ref) {
  return BattleRepository(
    battleRemoteDataSource: ref.watch(battleRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});