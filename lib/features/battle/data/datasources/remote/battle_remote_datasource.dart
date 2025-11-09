import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

abstract class BattleRemoteDataSource {
  Future<void> sendShotToOpponent(int id, String userUniqueId, int x, int y, bool isHit);
}

class BattleRemoteDataSourceImpl implements BattleRemoteDataSource {
  final Dio _dio;

  BattleRemoteDataSourceImpl(this._dio);

  @override
  Future<void> sendShotToOpponent(int id, String userUniqueId, int x, int y, bool isHit) async {
    debugPrint('💛 BattleRemoteDataSourceImpl sendShotToOpponent - вызов dio');
    try {
      final Dio dio = _dio;
      final data = jsonEncode({
        'userUniqueId': userUniqueId,
        'x': x,
        'y': y,
        'isHit': isHit,
      });
      final response = await dio.post(
        '/api/game/send-shot-to-opponent/$id',
        data: data,
      );
      debugPrint('💚 BattleRemoteDataSourceImpl sendShotToOpponent - получен response: $response');
      return response.data;
    } on DioException catch (e) {
      debugPrint('💚 BattleRemoteDataSourceImpl sendShotToOpponent - ошибка: $e');
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      debugPrint('💚 BattleRemoteDataSourceImpl sendShotToOpponent - ошибка: $e');
      throw Exception('Failed to send shot to opponent: $e');
    }
  }


}
