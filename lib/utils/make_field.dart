import 'package:seabattle/shared/entities/ship.dart';
import 'package:flutter/material.dart';

List<List<CellState>> makeField(List<Ship> ships, int gridSize, [List<Shot> shots = const []]) {
  // Генерируем поле с учетом кораблей и запретных зон
  final f = List.generate(
    gridSize,
    (_) => List.generate(gridSize, (_) => CellState.empty),
  );
  for (final ship in ships) {
    // Сначала отмечаем клетки корабля
    final shipCells = <Offset>[];
    for (int i = 0; i < ship.size; i++) {
      int x =
          ship.x + (ship.orientation == ShipOrientation.horizontal ? i : 0);
      int y = ship.y + (ship.orientation == ShipOrientation.vertical ? i : 0);

      // Если хотя бы один выстрел попал в клетку корабля
      if (shots.any((shot) => shot.x == x && shot.y == y)) {
        // Проверяем все ли клетки корабля попали под огонь
        if (ship.isDead(shots)) {
          f[y][x] = CellState.dead;
        } else {
          f[y][x] = CellState.wound;
        }
      } else {
        f[y][x] = CellState.ship;
      }
      shipCells.add(Offset(x.toDouble(), y.toDouble()));
    }
    // Если режим установки кораблей
    // отмечаем запретные зоны вокруг каждой палубы
    if (shots.isEmpty) {
      for (final cell in shipCells) {
        for (int dx = -1; dx <= 1; dx++) {
          for (int dy = -1; dy <= 1; dy++) {
            int nx = cell.dx.toInt() + dx;
            int ny = cell.dy.toInt() + dy;
            if (nx >= 0 && nx < gridSize && ny >= 0 && ny < gridSize) {
              if (f[ny][nx] == CellState.empty) {
                f[ny][nx] = CellState.forbidden;
              }
            }
          }
        }
      }
    }
  }

  // если режим боя, отмечаем промахи
  if (shots.isNotEmpty) {
    for (final shot in shots) {
      if (f[shot.y][shot.x] == CellState.empty) {
        f[shot.y][shot.x] = CellState.miss;
      }
    }
  }
  return f;
}