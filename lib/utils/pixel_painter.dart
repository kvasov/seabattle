import 'package:flutter/material.dart';
import 'package:seabattle/shared/entities/pixel_particle.dart';

// Отрисовка пиксельных частиц
class PixelPainter extends CustomPainter {
  final List<PixelParticle> particles;
  final double animationProgress;

  PixelPainter(this.particles, {required this.animationProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final opacity = (1.0 - animationProgress).clamp(0.0, 1.0);

    for (var p in particles) {
      if (p.isDead) continue;
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

