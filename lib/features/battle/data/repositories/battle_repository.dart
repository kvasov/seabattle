import '../datasources/remote/battle_remote_datasource.dart';
import 'package:flutter/foundation.dart';
import 'package:seabattle/core/result.dart';
import 'package:seabattle/core/services/network_info_service.dart';

class BattleRepository {
  final BattleRemoteDataSource battleRemoteDataSource;
  final NetworkInfoService networkInfo;

  BattleRepository({
    required this.battleRemoteDataSource,
    required this.networkInfo,
  });

  RequestOperation<void> sendShotToOpponent(int id, String userUniqueId, int x, int y, bool isHit) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      debugPrint('💚❤️♠️ BattleRepository: No internet connection');
      return Result.error(Failure(description: 'No internet connection'));
    }
    try {
      await battleRemoteDataSource.sendShotToOpponent(id, userUniqueId, x, y, isHit);
      return Result.ok(null);
    } catch (e) {
      debugPrint('💚❤️♠️ BattleRepository: Failed to send shot to opponent: $e');
      return Result.error(Failure(description: 'Failed to send shot to opponent: $e'));
    }
  }


}
