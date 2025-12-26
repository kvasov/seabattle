import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:seabattle/features/qr/data/datasources/remote/qr_remote_datasource.dart';
import 'package:seabattle/shared/entities/ship.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late QRRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = QRRemoteDataSourceImpl(mockDio);
  });

  group('QRRemoteDataSourceImpl тесты обработки сетевых ошибок', () {
    group('createGame', () {
      test('должен вернуть данные при успешном ответе', () async {
        // Мок для успешного ответа
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer(
          (_) async => Response<dynamic>(
            data: {'id': 123, 'name': 'test'},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/game'),
          ),
        );

        final result = await dataSource.createGame();

        expect(result['id'], equals(123));
        expect(result['name'], equals('test'));
        verify(() => mockDio.post('/api/game', data: {'name': 'test'})).called(1);
      });

      test('должен обработать DioException с ошибкой от сервера (400)', () async {
        // Мок для ошибки 400
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/game'),
            response: Response<dynamic>(
              data: {'error': 'Bad request'},
              statusCode: 400,
              requestOptions: RequestOptions(path: '/api/game'),
            ),
          ),
        );

        expect(
          () => dataSource.createGame(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Bad request'),
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
            requestOptions: RequestOptions(path: '/api/game'),
            response: Response<dynamic>(
              data: {'error': 'Internal server error'},
              statusCode: 500,
              requestOptions: RequestOptions(path: '/api/game'),
            ),
          ),
        );

        expect(
          () => dataSource.createGame(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Internal server error'),
          )),
        );
      });
    });

    group('sendShipsToOpponent', () {
      test('должен успешно отправить корабли', () async {
        // Мок для успешного ответа
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer(
          (_) async => Response<dynamic>(
            data: {},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/game/send-ships-to-opponent/1'),
          ),
        );

        final ships = [
          Ship(0, 0, 4, ShipOrientation.horizontal),
          Ship(0, 2, 3, ShipOrientation.vertical),
        ];

        await dataSource.sendShipsToOpponent(1, 'test', ships);

        verify(() => mockDio.post(
              '/api/game/send-ships-to-opponent/1',
              data: any(named: 'data'),
            )).called(1);
      });

      test('должен обработать DioException при отправке кораблей', () async {
        // Мок для ошибки
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/game/send-ships-to-opponent/1'),
            response: Response<dynamic>(
              data: {'error': 'Invalid ships'},
              statusCode: 400,
              requestOptions: RequestOptions(path: '/api/game/send-ships-to-opponent/1'),
            ),
          ),
        );

        final ships = [
          Ship(0, 0, 4, ShipOrientation.horizontal),
        ];

        expect(
          () => dataSource.sendShipsToOpponent(1, 'test', ships),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid ships'),
          )),
        );
      });
    });
  });
}
