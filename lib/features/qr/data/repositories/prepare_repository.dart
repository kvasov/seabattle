import 'package:flutter/foundation.dart';
import '../datasources/remote/qr_remote_datasource.dart';
import 'package:seabattle/shared/entities/game.dart';
import 'package:seabattle/core/result.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/core/services/network_info_service.dart';

class PrepareRepository {
  final QRRemoteDataSource qrRemoteDataSource;
  final NetworkInfoService networkInfo;

  PrepareRepository({
    required this.qrRemoteDataSource,
    required this.networkInfo,
  });

  RequestOperation<GameModel> createGame() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Result.error(Failure(description: 'No internet connection'));
    }
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
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Result.error(Failure(description: 'No internet connection'));
    }
    try {
      final response = await qrRemoteDataSource.updateGame(id, action, userUniqueId);
      if (response.containsKey('id') && !response.containsKey('error')) {
        final responseId = response['id'] as int;
        DateTime createdAt = DateTime.now();
        if (response.containsKey('createdAt')) {
          try {
            createdAt = DateTime.parse(response['createdAt'] as String);
          } catch (e) {
            createdAt = DateTime.now();
          }
        }

        return Result.ok(GameModel.fromDto(
          GameModelDto(
            id: responseId,
            createdAt: createdAt,
          )
        ));
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
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      debugPrint('🔥 No internet connection');
      return Result.error(Failure(description: 'No internet connection'));
    }
    try {
      await qrRemoteDataSource.sendShipsToOpponent(id, userUniqueId, ships);
      return Result.ok(null);
    } catch (e) {
      throw Exception('Failed to send ships to opponent: $e');
    }
  }
}
