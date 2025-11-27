import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:seabattle/shared/entities/game.dart';
import 'package:seabattle/shared/entities/ship.dart';

abstract class QRRemoteDataSource {
  Future<Map<String, dynamic>> createGame();
  Future<Map<String, dynamic>> updateGame(int id, GameAction action, String userUniqueId);
  Future<void> sendShipsToOpponent(int id, String userUniqueId, List<Ship> ships);
}

class QRRemoteDataSourceImpl implements QRRemoteDataSource {
  final Dio _dio;

  QRRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> createGame() async {
    // debugPrint('💛 QRRemoteDataSourceImpl createGame - вызов dio');
    try {
      final Dio dio = _dio;
      final response = await dio.post(
        '/api/game',
        data: {
          'name': 'test',
        },
      );
      // debugPrint('💚 QRRemoteDataSourceImpl createGame - получен response: $response');
      return response.data;
    } on DioException catch (e) {
      // debugPrint('💚 QRRemoteDataSourceImpl createGame - ошибка: $e');
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      // debugPrint('💚 QRRemoteDataSourceImpl createGame - ошибка: $e');
      throw Exception('Failed to create game: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateGame(int id, GameAction action, String userUniqueId) async {
    // debugPrint('💛 QRRemoteDataSourceImpl updateGame - вызов dio');

    try {
      final Dio dio = _dio;
      Response<dynamic> response;
      switch (action) {
        case GameAction.accept:
          response = await dio.post(
            '/api/game/accept/$id',
            data: {
              'userUniqueId': userUniqueId,
            },
          );
          break;
        case GameAction.ready:
          response = await dio.post(
            '/api/game/ready/$id',
            data: {
              'userUniqueId': userUniqueId,
            },
          );
          break;
        case GameAction.cancel:
          response = await dio.post(
            '/api/game/cancel/$id',
            data: {
              'userUniqueId': userUniqueId,
            },
          );
          break;
        case GameAction.complete:
          response = await dio.post(
            '/api/game/complete/$id',
          );
          break;
      }

      // debugPrint('💚 QRRemoteDataSourceImpl updateGame - получен response: $response');
      return response.data;
    } on DioException catch (e) {
      // debugPrint('💚 QRRemoteDataSourceImpl createGame - ошибка: $e');
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      // debugPrint('💚 QRRemoteDataSourceImpl createGame - ошибка: $e');
      throw Exception('Failed to create game: $e');
    }
  }

  @override
  Future<void> sendShipsToOpponent(int id, String userUniqueId, List<Ship> ships) async {
    try {
      final Dio dio = _dio;
      final data = jsonEncode({
        'userUniqueId': userUniqueId,
        'ships': ships.map((ship) => ship.toJson()).toList(),
      });
      await dio.post(
        '/api/game/send-ships-to-opponent/$id',
        data: data,
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      throw Exception('Failed to send ships to opponent: $e');
    }
  }
}
