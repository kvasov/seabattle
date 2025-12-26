import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/entities/game.dart';
import 'package:seabattle/features/qr/data/repositories/prepare_repository.dart';
import 'package:seabattle/core/result.dart';
import 'package:seabattle/shared/providers/repositories/prepare_repository_provider.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/shared/providers/user_provider.dart';

// Моки для зависимостей
class MockPrepareRepository extends Mock implements PrepareRepository {}

void main() {
  late ProviderContainer container;
  late MockPrepareRepository mockRepository;

  setUp(() {
    mockRepository = MockPrepareRepository();
  });

  tearDown(() {
    container.dispose();
  });

  group('GameNotifier тесты emitting состояний', () {
    test('должен эмитить loading состояние при вызове createGame', () async {
      // Мок репозитория
      when(() => mockRepository.createGame()).thenAnswer(
        (_) async => Result.ok(GameModel.fromDto(GameModelDto(id: 1, createdAt: DateTime.now()))),
      );

      // Контейнер с переопределенными провайдерами
      container = ProviderContainer(
        overrides: [
          prepareRepositoryProvider.overrideWithValue(mockRepository),
          navigationProvider.overrideWith(() => NavigationNotifier()),
          userUniqueIdProvider.overrideWith((ref) => '123123'),
        ],
      );

      final notifier = container.read(gameNotifierProvider.notifier);
      final states = <AsyncValue<GameState>>[];

      // Подписываемся на изменения состояния
      container.listen(
        gameNotifierProvider,
        (previous, next) {
          states.add(next);
        },
        fireImmediately: true,
      );

      // Ждем инициализации провайдера
      await container.read(gameNotifierProvider.future);

      // Проверяем начальное состояние
      final initialState = container.read(gameNotifierProvider);
      expect(initialState.hasValue, isTrue);
      expect(initialState.value?.game, isNull);

      // Вызываем createGame
      final createGameFuture = notifier.createGame();

      // Ждем завершения
      await createGameFuture;

      // Проверяем финальное состояние
      final finalState = container.read(gameNotifierProvider);
      expect(finalState.hasValue, isTrue);
      expect(finalState.value?.game?.id, equals(1));

      // Проверяем, что было хотя бы одно изменение состояния
      expect(states.length, greaterThan(1));
    });

    test('должен эмитить data состояние с игрой после успешного createGame', () async {
      final testGame = GameModel.fromDto(GameModelDto(id: 123, createdAt: DateTime.now()));

      when(() => mockRepository.createGame()).thenAnswer(
        (_) async => Result.ok(testGame),
      );

      container = ProviderContainer(
        overrides: [
          prepareRepositoryProvider.overrideWithValue(mockRepository),
          navigationProvider.overrideWith(() => NavigationNotifier()),
          userUniqueIdProvider.overrideWith((ref) => '123123'),
        ],
      );

      final notifier = container.read(gameNotifierProvider.notifier);
      final states = <AsyncValue<GameState>>[];

      container.listen(
        gameNotifierProvider,
        (previous, next) {
          states.add(next);
        },
        fireImmediately: true,
      );

      await notifier.createGame();

      // Проверяем финальное состояние
      final finalState = container.read(gameNotifierProvider);
      expect(finalState.hasValue, isTrue);
      expect(finalState.value?.game?.id, equals(123));
      expect(finalState.value?.game?.master, isTrue);
    });

    test('должен эмитить error состояние при ошибке createGame', () async {
      when(() => mockRepository.createGame()).thenAnswer(
        (_) async => Result.error(Failure(description: 'Network error')),
      );

      container = ProviderContainer(
        overrides: [
          prepareRepositoryProvider.overrideWithValue(mockRepository),
          navigationProvider.overrideWith(() => NavigationNotifier()),
          userUniqueIdProvider.overrideWith((ref) => '123123'),
        ],
      );

      final notifier = container.read(gameNotifierProvider.notifier);
      final states = <AsyncValue<GameState>>[];

      container.listen(
        gameNotifierProvider,
        (previous, next) {
          states.add(next);
        },
        fireImmediately: true,
      );

      await notifier.createGame();

      // Проверяем, что было состояние error
      final finalState = container.read(gameNotifierProvider);
      expect(finalState.hasError, isTrue);
      expect(finalState.error.toString(), contains('Network error'));
    });
  });
}
