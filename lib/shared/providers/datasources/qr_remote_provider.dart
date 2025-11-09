import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/qr/data/datasources/remote/qr_remote_datasource.dart';
import 'package:seabattle/shared/providers/datasources/dio_provider.dart';

final qrRemoteDataSourceProvider = Provider<QRRemoteDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return QRRemoteDataSourceImpl(dio);
});