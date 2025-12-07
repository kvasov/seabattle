import 'package:flutter/material.dart';

class PixelParticle {
  Offset position;
  Offset velocity;
  Color color;
  double life = 1.0;

  static const gravity = 0.08;
  static const friction = 0.96;

  PixelParticle({
    required this.position,
    required this.velocity,
    required this.color,
  });

  void update() {
    velocity = Offset(velocity.dx * friction, velocity.dy * friction + gravity);
    position += velocity;
  }

  bool get isDead => life <= 0;
}

