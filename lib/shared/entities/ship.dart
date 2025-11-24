import 'package:equatable/equatable.dart';

enum CellState {
  empty,
  ship,
  forbidden,
  wound,
  miss,
  dead,
  cursor
}

enum ShipOrientation { horizontal, vertical }

class Ship {
  final int x;
  final int y;
  final int size;
  final ShipOrientation orientation;
  bool dead;

  Ship(
    this.x,
    this.y,
    this.size,
    this.orientation, {
    this.dead = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'size': size,
      'orientation': orientation.name,
      'dead': dead,
    };
  }

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

  bool isWounded(int x, int y) {
    if (orientation == ShipOrientation.horizontal) {
      return this.x <= x && x <= this.x + size - 1 && this.y == y;
    } else {
      return this.y <= y && y <= this.y + size - 1 && this.x == x;
    }
  }

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

  // проверить убит ли корабль этим выстрелом
  bool isDeadByShot(Shot shot, List<Shot> shots) {
    return isWounded(shot.x, shot.y) && isDead(shots);
  }
}

class Shot {
  final int x;
  final int y;

  Shot(this.x, this.y);

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