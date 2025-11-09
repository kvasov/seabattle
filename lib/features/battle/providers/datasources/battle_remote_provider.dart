import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/battle/data/datasources/remote/battle_remote_datasource.dart';
import 'package:seabattle/shared/providers/datasources/dio_provider.dart';

final battleRemoteDataSourceProvider = Provider<BattleRemoteDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return BattleRemoteDataSourceImpl(dio);
});