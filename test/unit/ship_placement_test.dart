import 'package:flutter_test/flutter_test.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/utils/ship_placement_utils.dart';

void main() {
  group('canPlaceShipPure тесты', () {
    test('должен разрешать размещение корабля на пустом поле', () {
      final ships = <Ship>[];
      final gridSize = 10;

      final canPlace = canPlaceShipPure(
        2, 3, 3, ShipOrientation.horizontal, ships, gridSize,
      );

      expect(canPlace, true);
    });

    test('должен запрещать размещение корабля за границами поля', () {
      final ships = <Ship>[];
      final gridSize = 10;

      expect(canPlaceShipPure(8, 3, 3, ShipOrientation.horizontal, ships, gridSize), false);
      expect(canPlaceShipPure(3, 8, 3, ShipOrientation.vertical, ships, gridSize), false);
    });

    test('должен запрещать размещение корабля на занятой клетке', () {
      final ships = [
        Ship(5, 5, 2, ShipOrientation.horizontal),
      ];
      final gridSize = 10;

      final canPlace = canPlaceShipPure(
        5, 5, 3, ShipOrientation.horizontal, ships, gridSize,
      );

      expect(canPlace, false);
    });

    test('должен запрещать размещение корабля рядом с другим кораблем', () {
      final ships = [
        Ship(5, 5, 2, ShipOrientation.horizontal),
      ];
      final gridSize = 10;

      expect(canPlaceShipPure(3, 5, 2, ShipOrientation.horizontal, ships, gridSize), false);
      expect(canPlaceShipPure(7, 5, 2, ShipOrientation.horizontal, ships, gridSize), false);
      expect(canPlaceShipPure(5, 4, 2, ShipOrientation.horizontal, ships, gridSize), false);
      expect(canPlaceShipPure(5, 6, 2, ShipOrientation.horizontal, ships, gridSize), false);
      expect(canPlaceShipPure(7, 6, 2, ShipOrientation.horizontal, ships, gridSize), false);
    });

    test('должен разрешать размещение корабля если расстояние до других кораблей достаточное', () {
      final ships = [
        Ship(5, 5, 2, ShipOrientation.horizontal),
      ];
      final gridSize = 10;

      expect(canPlaceShipPure(2, 5, 2, ShipOrientation.horizontal, ships, gridSize), true);
      expect(canPlaceShipPure(8, 5, 2, ShipOrientation.horizontal, ships, gridSize), true);
      expect(canPlaceShipPure(5, 2, 2, ShipOrientation.vertical, ships, gridSize), true);
      expect(canPlaceShipPure(5, 8, 2, ShipOrientation.vertical, ships, gridSize), true);
    });
  });
}
