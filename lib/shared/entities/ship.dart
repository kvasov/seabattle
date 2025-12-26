import 'package:equatable/equatable.dart';

/// Состояние ячейки игрового поля.
enum CellState {
  /// Пустая ячейка.
  empty,
  /// Ячейка с кораблем.
  ship,
  /// Запрещенная для размещения ячейка.
  forbidden,
  /// Раненый корабль.
  wound,
  /// Промах.
  miss,
  /// Убитый корабль.
  dead,
  /// Позиция курсора.
  cursor
}

/// Ориентация корабля на поле.
enum ShipOrientation {
  /// Горизонтальная ориентация.
  horizontal,
  /// Вертикальная ориентация.
  vertical
}

/// Представляет корабль на игровом поле.
class Ship {
  final int x;
  final int y;
  final int size;
  final ShipOrientation orientation;
  bool dead;

  /// Создает экземпляр корабля.
  ///
  /// [x] - координата X левого верхнего угла корабля.
  /// [y] - координата Y левого верхнего угла корабля.
  /// [size] - размер корабля (количество палуб).
  /// [orientation] - ориентация корабля.
  /// [dead] - флаг, указывающий, убит ли корабль.
  Ship(
    this.x,
    this.y,
    this.size,
    this.orientation, {
    this.dead = false,
  });

  /// Преобразует корабль в JSON формат.
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'size': size,
      'orientation': orientation.name,
      'dead': dead,
    };
  }

  /// Создает корабль из JSON.
  ///
  /// [json] - словарь с данными корабля.
  static Ship fromJson(Map<String, dynamic> json) {
    return Ship(
      json['x'],
      json['y'],
      json['size'],
      ShipOrientation.values.byName(json['orientation']),
      dead: json['dead'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Ship(x: $x, y: $y, size: $size, orientation: $orientation, dead: $dead)';
  }

  /// Проверяет, ранен ли корабль в указанной позиции.
  ///
  /// [x] - координата X.
  /// [y] - координата Y.
  /// Возвращает `true`, если корабль ранен в этой позиции.
  bool isWounded(int x, int y) {
    if (orientation == ShipOrientation.horizontal) {
      return this.x <= x && x <= this.x + size - 1 && this.y == y;
    } else {
      return this.y <= y && y <= this.y + size - 1 && this.x == x;
    }
  }

  /// Проверяет, убит ли корабль на основе списка выстрелов.
  ///
  /// [shots] - список всех выстрелов.
  /// Возвращает `true`, если все палубы корабля поражены.
  bool isDead(List<Shot> shots) {
    for (int i = 0; i < size; i++) {
      if (orientation == ShipOrientation.horizontal) {
        if (!shots.any((shot) => shot.x == x + i && shot.y == y)) {
          return false;
        }
      } else {
        if (!shots.any((shot) => shot.x == x && shot.y == y + i)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Проверяет, убит ли корабль данным выстрелом.
  ///
  /// [shot] - выстрел для проверки.
  /// [shots] - список всех выстрелов.
  /// Возвращает `true`, если корабль ранен этим выстрелом и убит.
  bool isDeadByShot(Shot shot, List<Shot> shots) {
    return isWounded(shot.x, shot.y) && isDead(shots);
  }
}

/// Представляет выстрел на игровом поле.
class Shot {
  /// Координата X выстрела.
  final int x;
  /// Координата Y выстрела.
  final int y;

  /// Создает экземпляр выстрела.
  ///
  /// [x] - координата X.
  /// [y] - координата Y.
  Shot(this.x, this.y);

  /// Преобразует выстрел в JSON формат.
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}

/// Позиция курсора в игровом поле
class GridPosition extends Equatable {
  final int x;
  final int y;

  const GridPosition(this.x, this.y);

  @override
  String toString() => 'GridPosition(x: $x, y: $y)';

  @override
  List<Object> get props => [x, y];
}