import 'package:flutter_test/flutter_test.dart';
import 'package:seabattle/shared/entities/ship.dart';

void main() {
  group('Ship тесты', () {
    test('isWounded должен возвращать true для попадания в горизонтальный корабль', () {
      final ship = Ship(2, 3, 3, ShipOrientation.horizontal);

      expect(ship.isWounded(2, 3), true);
      expect(ship.isWounded(3, 3), true);
      expect(ship.isWounded(4, 3), true);
      expect(ship.isWounded(1, 3), false);
      expect(ship.isWounded(5, 3), false);
      expect(ship.isWounded(2, 2), false);
      expect(ship.isWounded(2, 4), false);
    });

    test('isWounded должен возвращать true для попадания в вертикальный корабль', () {
      final ship = Ship(2, 3, 3, ShipOrientation.vertical);

      expect(ship.isWounded(2, 3), true);
      expect(ship.isWounded(2, 4), true);
      expect(ship.isWounded(2, 5), true);
      expect(ship.isWounded(2, 2), false);
      expect(ship.isWounded(2, 6), false);
      expect(ship.isWounded(1, 3), false);
      expect(ship.isWounded(3, 3), false);
    });

    test('isDead должен возвращать true когда все во клетки есть попадания', () {
      final ship = Ship(2, 3, 3, ShipOrientation.horizontal);
      final shots = [
        Shot(2, 3),
        Shot(3, 3),
        Shot(4, 3),
      ];

      expect(ship.isDead(shots), true);
    });

    test('isDead должен возвращать false когда не все во клетки есть попадания', () {
      final ship = Ship(2, 3, 3, ShipOrientation.horizontal);
      final shots = [
        Shot(2, 3),
        Shot(3, 3),
      ];

      expect(ship.isDead(shots), false);
    });

    test('isDeadByShot должен возвращать true когда корабль убит(добит) конкретным выстрелом', () {
      final ship = Ship(2, 3, 3, ShipOrientation.horizontal);
      final shots = [
        Shot(2, 3),
        Shot(3, 3),
        Shot(4, 3),
      ];
      final lastShot = Shot(4, 3);

      expect(ship.isDeadByShot(lastShot, shots), true);
    });
  });
}
