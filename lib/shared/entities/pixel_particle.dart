import 'package:flutter/material.dart';

/// Частица пикселя для эффекта взрыва корабля.
///
/// Представляет отдельную частицу с позицией, скоростью и цветом,
/// которая используется для создания эффекта взрыва.
class PixelParticle {
  /// Текущая позиция частицы.
  Offset position;

  /// Скорость движения частицы.
  Offset velocity;

  /// Цвет частицы.
  Color color;

  /// Жизненный цикл частицы (от 1.0 до 0.0).
  double life = 1.0;

  /// Константа гравитации для частиц.
  static const gravity = 0.08;

  /// Константа трения для частиц.
  static const friction = 0.96;

  /// Создает частицу пикселя.
  ///
  /// [position] - начальная позиция частицы.
  /// [velocity] - начальная скорость частицы.
  /// [color] - цвет частицы.
  PixelParticle({
    required this.position,
    required this.velocity,
    required this.color,
  });

  /// Обновляет состояние частицы (применяет физику).
  void update() {
    velocity = Offset(velocity.dx * friction, velocity.dy * friction + gravity);
    position += velocity;
  }

  /// Проверяет, мертва ли частица.
  bool get isDead => life <= 0;
}

