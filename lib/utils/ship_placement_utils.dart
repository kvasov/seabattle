import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/utils/make_field.dart';

/// Чистая функция для проверки возможности размещения корабля
/// Может использоваться как в viewmodel, так и в изоляте
bool canPlaceShipPure(
  int x,
  int y,
  int size,
  ShipOrientation orientation,
  List<Ship> ships,
  int gridSize,
) {
  final field = makeField(
    ships: ships,
    gridSize: gridSize,
    isCursorVisible: false,
  );

  // Проверяем границы и занятость клеток
  for (int i = 0; i < size; i++) {
    int nx = x + (orientation == ShipOrientation.horizontal ? i : 0);
    int ny = y + (orientation == ShipOrientation.vertical ? i : 0);

    if (nx < 0 || nx >= gridSize || ny < 0 || ny >= gridSize) return false;
    if (field[ny][nx] != CellState.empty) return false;
  }

  // Проверяем ореол вокруг корабля
  for (int i = 0; i < size; i++) {
    int cx = x + (orientation == ShipOrientation.horizontal ? i : 0);
    int cy = y + (orientation == ShipOrientation.vertical ? i : 0);

    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        int nx = cx + dx;
        int ny = cy + dy;

        if (nx >= 0 && nx < gridSize && ny >= 0 && ny < gridSize) {
          if (field[ny][nx] == CellState.ship) return false;
        }
      }
    }
  }

  return true;
}

