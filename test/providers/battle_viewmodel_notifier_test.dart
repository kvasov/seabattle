import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seabattle/features/battle/presentation/viewmodels/battle_viewmodel.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/features/battle/data/repositories/battle_repository.dart';
import 'package:seabattle/features/battle/providers/repositories/battle_repository_provider.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/providers/user_provider.dart';

class MockBattleRepository extends Mock implements BattleRepository {}

void main() {
  late ProviderContainer container;
  late MockBattleRepository mockRepository;

  setUp(() {
    mockRepository = MockBattleRepository();
  });

  tearDown(() {
    container.dispose();
  });

  group('BattleViewModelNotifier тесты emitting состояний', () {
    test('должен емитить новое состояние при установке кораблей', () async {
      container = ProviderContainer(
        overrides: [
          battleRepositoryProvider.overrideWithValue(mockRepository),
          gameNotifierProvider.overrideWith(() => GameNotifier()),
          userUniqueIdProvider.overrideWith((ref) => '123123'),
        ],
      );

      final notifier = container.read(battleViewModelProvider.notifier);
      final states = <AsyncValue<BattleViewModelState>>[];

      container.listen(
        battleViewModelProvider,
        (previous, next) {
          states.add(next);
        },
        fireImmediately: true,
      );

      // Ждем инициализации
      await container.read(battleViewModelProvider.future);

      // Проверяем начальное состояние
      final initialState = container.read(battleViewModelProvider);
      expect(initialState.value?.ships.length, equals(0));

      final testShips = [
        Ship(0, 0, 4, ShipOrientation.horizontal),
        Ship(0, 2, 3, ShipOrientation.horizontal),
      ];

      // Устанавливаем корабли
      notifier.setShips(mode: 'self', ships: testShips);

      // Проверяем, что состояние изменилось
      final finalState = container.read(battleViewModelProvider);
      expect(finalState.hasValue, isTrue);
      expect(finalState.value?.ships.length, equals(2));
      expect(finalState.value?.ships[0].orientation, equals(ShipOrientation.horizontal));
      expect(finalState.value?.ships[0].size, equals(4));

      // Проверяем, что было несколько состояний
      expect(states.length, greaterThan(1));
    });

    test('должен эмитить новое состояние при изменении myMove', () async {
      container = ProviderContainer(
        overrides: [
          battleRepositoryProvider.overrideWithValue(mockRepository),
          gameNotifierProvider.overrideWith(() => GameNotifier()),
          userUniqueIdProvider.overrideWith((ref) => '123123'),
        ],
      );

      final notifier = container.read(battleViewModelProvider.notifier);
      final states = <AsyncValue<BattleViewModelState>>[];

      container.listen(
        battleViewModelProvider,
        (previous, next) {
          states.add(next);
        },
        fireImmediately: true,
      );

      await container.read(battleViewModelProvider.future);

      // Проверяем начальное состояние
      final initialState = container.read(battleViewModelProvider);
      expect(initialState.value?.myMove, isFalse);

      // Устанавливаем myMove в true
      notifier.setMyMove(true);

      // Проверяем новое состояние
      final newState = container.read(battleViewModelProvider);
      expect(newState.value?.myMove, isTrue);

      // Проверяем, что было 2 состояния
      expect(states.length, greaterThanOrEqualTo(2));

      // Устанавливаем обратно в false
      notifier.setMyMove(false);
      final finalState = container.read(battleViewModelProvider);
      expect(finalState.value?.myMove, isFalse);

      // Проверяем, что было 3 состояния
      expect(states.length, greaterThanOrEqualTo(3));
    });
  });
}
