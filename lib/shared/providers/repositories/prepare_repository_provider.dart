import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/qr/data/repositories/prepare_repository.dart';
import 'package:seabattle/shared/providers/datasources/qr_remote_provider.dart';

final prepareRepositoryProvider = Provider<PrepareRepository>((ref) {
  return PrepareRepository(
    qrRemoteDataSource: ref.watch(qrRemoteDataSourceProvider),
  );
});