import 'package:flutter_test/flutter_test.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/utils/make_field.dart';

void main() {
  group('makeField тесты', () {
    test('должен создавать пустое поле указанного размера', () {
      final field = makeField(
        ships: [],
        gridSize: 5,
      );

      expect(field.length, 5);
      expect(field[0].length, 5);
      expect(field[2][1], CellState.empty);
    });

    test('должен размещать корабли на поле', () {
      final ships = [
        Ship(1, 1, 3, ShipOrientation.horizontal),
      ];
      final field = makeField(
        ships: ships,
        gridSize: 5,
      );

      expect(field[1][1], CellState.ship);
      expect(field[1][2], CellState.ship);
      expect(field[1][3], CellState.ship);
      expect(field[0][1], CellState.forbidden);
      expect(field[2][1], CellState.forbidden);
    });

    test('должен отмечать запретные зоны вокруг кораблей', () {
      final ships = [
        Ship(1, 1, 3, ShipOrientation.horizontal),
      ];
      final field = makeField(
        ships: ships,
        gridSize: 5,
      );

      expect(field[0][0], CellState.forbidden);
      expect(field[0][1], CellState.forbidden);
      expect(field[0][2], CellState.forbidden);
      expect(field[0][3], CellState.forbidden);
      expect(field[0][4], CellState.forbidden);
      expect(field[1][0], CellState.forbidden);
      expect(field[1][4], CellState.forbidden);
      expect(field[2][0], CellState.forbidden);
      expect(field[2][1], CellState.forbidden);
      expect(field[2][2], CellState.forbidden);
      expect(field[2][3], CellState.forbidden);
      expect(field[2][4], CellState.forbidden);

      expect(field[1][1], CellState.ship);
      expect(field[1][2], CellState.ship);
      expect(field[1][3], CellState.ship);

      expect(field[3][0], CellState.empty);
      expect(field[3][2], CellState.empty);
    });

    test('должен отмечать промахи на поле', () {
      final ships = [
        Ship(1, 1, 3, ShipOrientation.horizontal),
      ];
      final shots = [
        Shot(0, 0),
        Shot(2, 2),
      ];
      final field = makeField(
        ships: ships,
        gridSize: 5,
        shots: shots,
      );

      expect(field[0][0], CellState.miss);
      expect(field[2][2], CellState.miss);
    });

    test('должен отмечать раненые клетки корабля', () {
      final ships = [
        Ship(2, 3, 3, ShipOrientation.horizontal),
      ];
      final shots = [
        Shot(2, 3),
      ];
      final field = makeField(
        ships: ships,
        gridSize: 10,
        shots: shots,
      );

      expect(field[3][2], CellState.wound);
      expect(field[3][3], CellState.ship);
      expect(field[3][4], CellState.ship);
    });

    test('должен отмечать убитые корабли', () {
      final ships = [
        Ship(2, 3, 3, ShipOrientation.horizontal),
      ];
      final shots = [
        Shot(2, 3),
        Shot(3, 3),
        Shot(4, 3),
      ];
      final field = makeField(
        ships: ships,
        gridSize: 10,
        shots: shots,
      );

      expect(field[3][2], CellState.dead);
      expect(field[3][3], CellState.dead);
      expect(field[3][4], CellState.dead);
    });
  });
}
