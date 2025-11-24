import 'package:flutter/material.dart';
import 'package:seabattle/shared/entities/pixel_particle.dart';

/// Отрисовка всех пиксельных частиц
class PixelPainter extends CustomPainter {
  final List<PixelParticle> particles;
  final double animationProgress;

  PixelPainter(this.particles, {required this.animationProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // Вычисляем прозрачность на основе прогресса анимации (от 1.0 до 0.0)
    final opacity = (1.0 - animationProgress).clamp(0.0, 1.0);

    for (var p in particles) {
      if (p.isDead) continue;
      // Используем прогресс анимации для плавного затухания
      // withOpacity принимает значение от 0.0 до 1.0
      paint.color = p.color.withValues(alpha: opacity);
      canvas.drawRect(Rect.fromCenter(center: p.position, width: 1, height: 1), paint);
    }
  }

  @override
  bool shouldRepaint(PixelPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.particles.length != particles.length;
  }
}

