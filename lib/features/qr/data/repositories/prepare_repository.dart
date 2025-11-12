import 'package:flutter/foundation.dart';
import '../datasources/remote/qr_remote_datasource.dart';
import 'package:seabattle/shared/entities/game.dart';
import 'package:seabattle/core/result.dart';
import 'package:seabattle/shared/entities/ship.dart';

class PrepareRepository {
  final QRRemoteDataSource qrRemoteDataSource;

  PrepareRepository({
    required this.qrRemoteDataSource,
  });

  RequestOperation<GameModel> createGame() async {
    try {
      final response = await qrRemoteDataSource.createGame();
      if (response.containsKey('id')) {
        final id = response['id'] as int;
        return Result.ok(GameModel.fromDto(GameModelDto(id: id, createdAt: DateTime.now())));
      } else {
        throw Exception('Response does not contain id key');
      }
    } catch (e) {
      throw Exception('Failed to create game: $e');
    }
  }

  RequestOperation<GameModel> updateGame(int id, GameAction action, String userUniqueId) async {
    try {
      final response = await qrRemoteDataSource.updateGame(id, action, userUniqueId);
      if (response.containsKey('id') && !response.containsKey('error')) {
        return Result.ok(GameModel.fromDto(GameModelDto(id: id, createdAt: DateTime.now())));
      }
      else if (response.containsKey('error')) {
        return Result.error(Failure(description: response['error'] as String));
      } else {
        throw Exception('Response does not contain id key');
      }
    } catch (e) {
      throw Exception('Failed to update game: $e');
    }
  }

  RequestOperation<void> sendShipsToOpponent(int id, String userUniqueId, List<Ship> ships) async {
    try {
      await qrRemoteDataSource.sendShipsToOpponent(id, userUniqueId, ships);
      return Result.ok(null);
    } catch (e) {
      throw Exception('Failed to send ships to opponent: $e');
    }
  }
}
