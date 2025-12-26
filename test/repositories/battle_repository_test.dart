import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seabattle/features/battle/data/repositories/battle_repository.dart';
import 'package:seabattle/features/battle/data/datasources/remote/battle_remote_datasource.dart';
import 'package:seabattle/core/services/network_info_service.dart';

class MockBattleRemoteDataSource extends Mock implements BattleRemoteDataSource {}
class MockNetworkInfoService extends Mock implements NetworkInfoService {}

void main() {
  late BattleRepository repository;
  late MockBattleRemoteDataSource mockDataSource;
  late MockNetworkInfoService mockNetworkInfo;

  setUp(() {
    mockDataSource = MockBattleRemoteDataSource();
    mockNetworkInfo = MockNetworkInfoService();
    repository = BattleRepository(
      battleRemoteDataSource: mockDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('BattleRepository тесты обработки сетевых ошибок', () {
    group('sendShotToOpponent', () {
      test('должен вернуть ошибку при отсутствии интернета', () async {
        // Настраиваем мок: нет интернета
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Вызываем метод
        final result = await repository.sendShotToOpponent(1, 'test', 5, 5, true);

        // Проверяем результат
        expect(result.isError, isTrue);
        expect(result.error?.description, equals('No internet connection'));
        // Проверяем, что был вызван метод проверки интернета
        verify(() => mockNetworkInfo.isConnected).called(1);
        // verifyNever() - проверяет, что метод не был вызван
        // Здесь это нужно, потому что при отсутствии интернета репозиторий должен вернуть ошибку
        // БЕЗ попытки выполнить сетевой запрос
        verifyNever(() => mockDataSource.sendShotToOpponent(any(), any(), any(), any(), any()));
      });

      test('должен вернуть успешный результат при наличии интернета', () async {
        // Настраиваем моки
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.sendShotToOpponent(any(), any(), any(), any(), any())).thenAnswer(
          (_) async => {},
        );

        final result = await repository.sendShotToOpponent(1, 'test', 5, 5, true);

        // Проверяем результат
        expect(result.isSuccess, isTrue);
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockDataSource.sendShotToOpponent(1, 'test', 5, 5, true)).called(1);
      });

      test('должен обработать исключение при отправке выстрела', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.sendShotToOpponent(any(), any(), any(), any(), any())).thenThrow(
          Exception('Network error'),
        );

        final result = await repository.sendShotToOpponent(1, 'test', 5, 5, true);

        // Проверяем результат - должен быть Result.error
        expect(result.isError, isTrue);
        expect(result.error?.description, contains('Failed to send shot to opponent'));
      });

      test('должен корректно передавать параметры в data source', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.sendShotToOpponent(any(), any(), any(), any(), any())).thenAnswer(
          (_) async => {},
        );

        await repository.sendShotToOpponent(123, 'test', 10, 20, false);

        // Проверяем, что параметры переданы корректно
        verify(() => mockDataSource.sendShotToOpponent(123, 'test', 10, 20, false)).called(1);
      });
    });
  });
}
