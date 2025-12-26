import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seabattle/features/qr/data/repositories/prepare_repository.dart';
import 'package:seabattle/features/qr/data/datasources/remote/qr_remote_datasource.dart';
import 'package:seabattle/core/services/network_info_service.dart';

class MockQRRemoteDataSource extends Mock implements QRRemoteDataSource {}
class MockNetworkInfoService extends Mock implements NetworkInfoService {}

void main() {
  late PrepareRepository repository;
  late MockQRRemoteDataSource mockDataSource;
  late MockNetworkInfoService mockNetworkInfo;

  setUp(() {
    mockDataSource = MockQRRemoteDataSource();
    mockNetworkInfo = MockNetworkInfoService();
    repository = PrepareRepository(
      qrRemoteDataSource: mockDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('PrepareRepository тесты обработки сетевых ошибок', () {
    group('createGame', () {
      test('должен вернуть ошибку при отсутствии интернета', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        final result = await repository.createGame();

        expect(result.isError, isTrue);
        expect(result.error?.description, equals('No internet connection'));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNever(() => mockDataSource.createGame());
      });

      test('должен вернуть успешный результат при наличии интернета и валидном ответе', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.createGame()).thenAnswer(
          (_) async => {'id': 123, 'createdAt': '2024-01-01T00:00:00Z'},
        );

        final result = await repository.createGame();

        expect(result.isSuccess, isTrue);
        expect(result.data?.id, equals(123));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockDataSource.createGame()).called(1);
      });

      test('должен вернуть ошибку при отсутствии id в ответе', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.createGame()).thenAnswer(
          (_) async => {'name': 'test'},
        );

        // Вызываем метод - метод бросает Exception при отсутствии id
        expect(
          () => repository.createGame(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Response does not contain id key'),
          )),
        );
      });

      test('должен обработать DioException с ошибкой от сервера', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.createGame()).thenThrow(
          Exception('Network error'),
        );

        expect(
          () => repository.createGame(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to create game'),
          )),
        );
      });
    });
  });
}
