import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:seabattle/features/battle/data/datasources/remote/battle_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late BattleRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = BattleRemoteDataSourceImpl(mockDio);
  });

  group('BattleRemoteDataSourceImpl тесты обработки сетевых ошибок', () {
    group('sendShotToOpponent', () {
      test('должен успешно отправить выстрел', () async {
        // Мок для успешного ответа от Dio
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer(
          (_) async => Response<dynamic>(
            data: {},
            statusCode: 200,
            // requestOptions - метаданные запроса, необходимые для создания Response
            requestOptions: RequestOptions(path: '/api/game/send-shot-to-opponent/1'),
          ),
        );

        await dataSource.sendShotToOpponent(1, 'test', 5, 5, true);

        // Проверяем, что метод был вызван с правильными параметрами
        verify(() => mockDio.post(
              '/api/game/send-shot-to-opponent/1',
              data: any(named: 'data'),
            )).called(1);
      });

      test('должен обработать DioException с ошибкой от сервера (400)', () async {
        // Мок для ошибки 400
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/game/send-shot-to-opponent/1'),
            response: Response<dynamic>(
              data: {'error': 'Invalid shot'},
              statusCode: 400,
              requestOptions: RequestOptions(path: '/api/game/send-shot-to-opponent/1'),
            ),
          ),
        );

        // Вызываем метод и проверяем исключение
        expect(
          () => dataSource.sendShotToOpponent(1, 'test', 5, 5, true),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid shot'),
          )),
        );
      });

      test('должен обработать DioException без response (сетевые ошибки)', () async {
        // Настраиваем мок для сетевой ошибки без response
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/game/send-shot-to-opponent/1'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Вызываем метод и проверяем исключение
        expect(
          () => dataSource.sendShotToOpponent(1, 'test', 5, 5, true),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Network error'),
          )),
        );
      });

      test('должен обработать DioException с ошибкой 500', () async {
        // Мок для ошибки сервера
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/game/send-shot-to-opponent/1'),
            response: Response<dynamic>(
              data: {'error': 'Internal server error'},
              statusCode: 500,
              requestOptions: RequestOptions(path: '/api/game/send-shot-to-opponent/1'),
            ),
          ),
        );

        expect(
          () => dataSource.sendShotToOpponent(1, 'test', 5, 5, true),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Internal server error'),
          )),
        );
      });

      test('должен обработать разные значения isHit', () async {
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer(
          (_) async => Response<dynamic>(
            data: {},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/game/send-shot-to-opponent/1'),
          ),
        );

        // если isHit = true
        await dataSource.sendShotToOpponent(1, 'test', 5, 5, true);
        verify(() => mockDio.post(
              '/api/game/send-shot-to-opponent/1',
              data: any(named: 'data'),
            )).called(1);

        // если isHit = false
        await dataSource.sendShotToOpponent(1, 'test', 5, 5, false);
        verify(() => mockDio.post(
              '/api/game/send-shot-to-opponent/1',
              data: any(named: 'data'),
            )).called(1);
      });
    });
  });
}
