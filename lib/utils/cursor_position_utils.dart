import 'package:seabattle/shared/entities/ship.dart';

/// Вычисляет новую позицию курсора на основе текущей позиции и направления движения
///
/// [currentPosition] - текущая позиция курсора
/// [direction] - направление движения ('up', 'down', 'left', 'right')
/// [gridSize] - размер сетки (по умолчанию 10)
///
/// Возвращает новую позицию курсора с учетом границ сетки (циклический переход)
GridPosition calculateNewCursorPosition(
  GridPosition? currentPosition,
  String direction,
  int gridSize,
) {
  final current = currentPosition ?? GridPosition(0, 0);

  switch (direction) {
    case 'up':
      if (current.y > 0) {
        return GridPosition(current.x, current.y - 1);
      } else {
        return GridPosition(current.x, gridSize - 1);
      }
    case 'down':
      if (current.y < gridSize - 1) {
        return GridPosition(current.x, current.y + 1);
      } else {
        return GridPosition(current.x, 0);
      }
    case 'left':
      if (current.x > 0) {
        return GridPosition(current.x - 1, current.y);
      } else {
        return GridPosition(gridSize - 1, current.y);
      }
    case 'right':
      if (current.x < gridSize - 1) {
        return GridPosition(current.x + 1, current.y);
      } else {
        return GridPosition(0, current.y);
      }
    default:
      return current;
  }
}

