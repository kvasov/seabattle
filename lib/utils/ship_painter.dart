import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/shared/providers/ships_images_provider.dart';

class SeaBattlePainter extends CustomPainter {
  final bool? myShips;
  final ShipsImagesCache? shipsImagesCache;
  final bool? battleMode;
  final List<List<CellState>> field;
  final double cellSize;
  final List<Ship>? ships;
  final Animation<double>? waveAnimation;
  final double rotationAmplitude;

  SeaBattlePainter({
    this.myShips = true,
    this.shipsImagesCache,
    this.battleMode = false,
    required this.field,
    required this.cellSize,
    this.ships,
    this.waveAnimation,
    this.rotationAmplitude = 0.05,
  }) : super(repaint: waveAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    // debugPrint('🤍🧡🤍💚🤍🩵🤍🤎🤍 paint: ${waveAnimation?.value}');
    // Заливка пустых клеток
    final emptyPaint =
        Paint()
          ..color = Colors.blue.shade50
          ..style = PaintingStyle.fill;
    // Заливка запрещенных клеток
    final forbiddenPaint =
        Paint()
          ..color = const Color.fromARGB(255, 38, 141, 220).withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;
    // Заливка промахов
    final missPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
    // Заливка попаданий
    final woundPaint =
        Paint()
          ..color = Colors.red.shade200
          ..style = PaintingStyle.fill;
    // Заливка убитых кораблей
    final deadPaint =
        Paint()
          ..color = Colors.red.shade700
          ..style = PaintingStyle.fill;

    // Рисуем клетки
    for (int y = 0; y < field.length; y++) {
      for (int x = 0; x < field[y].length; x++) {
        if (field[y][x] == CellState.empty) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            emptyPaint,
          );
        } else if (field[y][x] == CellState.forbidden) {
          if (battleMode == false) {
            canvas.drawRect(
              Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
              forbiddenPaint,
            );
          } else {
            canvas.drawRect(
              Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
              emptyPaint,
            );
          }
        } else if (field[y][x] == CellState.miss) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            missPaint,
          );
        } else if (field[y][x] == CellState.wound) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            woundPaint,
          );
        } else if (field[y][x] == CellState.dead) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            deadPaint,
          );
        }
      }
    }

    // Затем рисуем корабли
    // Первоначальный вариант с коряблями-клеточками

    // final shipPaint =
    //     Paint()
    //       ..color = myShips == true ? Colors.grey[500]! : Colors.grey[300]!
    //       ..style = PaintingStyle.fill;
    // final shipBorder =
    //     Paint()
    //       ..color = myShips == true ? Colors.black : Colors.grey[500]!
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 1;
    // for (int y = 0; y < field.length; y++) {
    //   for (int x = 0; x < field[y].length; x++) {
    //     if (field[y][x] == CellState.ship) {
    //       final rect = Rect.fromLTWH(
    //         x * cellSize + 1,
    //         y * cellSize + 1,
    //         cellSize - 2,
    //         cellSize - 2,
    //       );
    //       canvas.drawRect(rect, shipPaint);
    //       canvas.drawRect(rect, shipBorder);
    //     }
    //   }
    // }


    // Вариант для кораблей-картинок. Все клетки должны быть закрашены как "пустые"
    // потому что картинки с кораблями имеют прозрачный фон
    for (int y = 0; y < field.length; y++) {
      for (int x = 0; x < field[y].length; x++) {
        if (field[y][x] == CellState.ship) {
          final rect = Rect.fromLTWH(
            x * cellSize + 1,
            y * cellSize + 1,
            cellSize - 2,
            cellSize - 2,
          );
          canvas.drawRect(rect, emptyPaint);

        }
      }
    }

    // Сетка
    final gridPaint =
        Paint()
          ..color = Colors.blue.shade200
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
    for (int i = 0; i <= field.length; i++) {
      canvas.drawLine(
        Offset(i * cellSize, 0),
        Offset(i * cellSize, cellSize * field.length),
        gridPaint,
      );
      canvas.drawLine(
        Offset(0, i * cellSize),
        Offset(cellSize * field.length, i * cellSize),
        gridPaint,
      );
    }

    // Рисуем корабли картинками
    if (shipsImagesCache != null && ships != null && ships!.isNotEmpty) {
      for (final ship in ships!) {
        // Получаем картинку корабля
        final shipImage = shipsImagesCache!.imageForSize(ship.size);
        if (shipImage == null) continue;

        final width = ship.orientation == ShipOrientation.horizontal ? cellSize * ship.size : cellSize;
        final height = ship.orientation == ShipOrientation.vertical ? cellSize * ship.size : cellSize;
        final rect = Rect.fromLTWH(
          ship.x * cellSize,
          ship.y * cellSize,
          width,
          height,
        );

        final shipPhaseOffset = (ship.x / 10 * math.pi + ship.y / 10 * math.pi) + math.pi / ship.size;
        final animationPhase = (waveAnimation?.value ?? 0.0) * math.pi;
        final phase = animationPhase + shipPhaseOffset;

        final swayOffset = math.sin(phase) * cellSize * 0.06;
        final tiltAngle = math.sin(phase) * rotationAmplitude;

        canvas.save();
        final center = rect.center;
        canvas.translate(center.dx + swayOffset, center.dy);
        final baseRotation = ship.orientation == ShipOrientation.vertical ? math.pi / 2 : 0.0;
        canvas.rotate(baseRotation + tiltAngle);

        final drawWidth = ship.orientation == ShipOrientation.horizontal ? rect.width : rect.height;
        final drawHeight = ship.orientation == ShipOrientation.horizontal ? rect.height : rect.width;
        final drawRect = Rect.fromCenter(
          center: Offset.zero,
          width: drawWidth,
          height: drawHeight,
        );

        paintImage(
          canvas: canvas,
          rect: drawRect,
          image: shipImage,
          fit: BoxFit.fill,
        );
        canvas.restore();
      }
    }

    // Рисуем попадания и промахи
    for (int y = 0; y < field.length; y++) {
      for (int x = 0; x < field[y].length; x++) {
        if (field[y][x] == CellState.miss) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            missPaint,
          );
        } else if (field[y][x] == CellState.wound) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            woundPaint,
          );
        } else if (field[y][x] == CellState.dead) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            deadPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant SeaBattlePainter oldDelegate) {
    return oldDelegate.waveAnimation != waveAnimation;
  }
}