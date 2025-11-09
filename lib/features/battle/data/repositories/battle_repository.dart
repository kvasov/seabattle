import '../datasources/remote/battle_remote_datasource.dart';
import 'package:seabattle/core/result.dart';

class BattleRepository {
  final BattleRemoteDataSource battleRemoteDataSource;

  BattleRepository({
    required this.battleRemoteDataSource,
  });

  RequestOperation<void> sendShotToOpponent(int id, String userUniqueId, int x, int y, bool isHit) async {
    try {
      await battleRemoteDataSource.sendShotToOpponent(id, userUniqueId, x, y, isHit);
      return Result.ok(null);
    } catch (e) {
      throw Exception('Failed to send shot to opponent: $e');
    }
  }


}
