import 'dart:math' as math;
import 'package:flutter/material.dart';

class FireworkParticle {
  Offset position;
  Offset velocity;
  Color color;
  double life;
  double size;

  FireworkParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.life,
    this.size = 3.0,
  });

  void update(double animationProgress) {
    // Применяем гравитацию
    velocity = Offset(velocity.dx * 0.98, velocity.dy * 0.98 + 0.05);
    position += velocity;
    life = 1.0 - animationProgress;
  }

  bool get isDead => life <= 0;
}

class FireworkPainter extends CustomPainter {
  final List<FireworkParticle> particles;
  final bool isAnimating;
  final double animationProgress;
  final String? text;
  final TextStyle? textStyle;

  FireworkPainter(
    this.particles, {
    this.isAnimating = true,
    required this.animationProgress,
    this.text,
    this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isAnimating) return;

    final alphaValue = animationProgress >= 0.7
      ? 0.7 * (1.0 - (animationProgress - 0.7) / 0.3)
      : 0.7;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black.withValues(alpha: alphaValue),
    );

    final paint = Paint()..style = .fill;

    for (var particle in particles) {
      // Прозрачность зависит от прогресса анимации (от 1.0 до 0.0)
      final opacity = 1.0 - animationProgress;
      paint.color = particle.color.withValues(alpha: opacity);

      canvas.drawCircle(
        particle.position,
        particle.size * opacity / 2.5,
        paint,
      );
    }

    // Рисуем текст, если он задан
    if (text != null && text!.isNotEmpty) {
      final textOpacity = 1.0 - animationProgress;
      final style = (textStyle ?? const TextStyle(
        color: Colors.white,
        fontSize: 36,
        fontWeight: .bold,
      )).copyWith(
        color: (textStyle?.color ?? Colors.white).withValues(alpha: textOpacity),
      );

      final textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textAlign: .center,
        textDirection: .ltr,
      );

      textPainter.layout();

      // Центрируем текст на экране
      final offset = Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      );

      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(FireworkPainter oldDelegate) {
    return oldDelegate.particles.length != particles.length ||
        oldDelegate.isAnimating != isAnimating ||
        oldDelegate.animationProgress != animationProgress ||
        oldDelegate.text != text ||
        oldDelegate.textStyle != textStyle;
  }
}

class FireworkWidget extends StatefulWidget {
  const FireworkWidget({
    super.key,
    this.particleCount = 800,
    this.duration = const Duration(seconds: 2),
    this.fireworkCount = 5,
    this.text,
    this.textStyle,
  });

  final int particleCount;
  final Duration duration;
  final int fireworkCount;
  final String? text;
  final TextStyle? textStyle;

  @override
  State<FireworkWidget> createState() => _FireworkWidgetState();
}

class _FireworkWidgetState extends State<FireworkWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<FireworkParticle> _particles = [];
  final math.Random _random = math.Random();

  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.cyan,
    Colors.lime,
    Colors.amber,
  ];

  Size? _lastSize;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(_updateParticles)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && _lastSize != null) {
          // Очищаем частицы и сбрасываем контроллер
          setState(() {
            _particles.clear();
          });
          _controller.reset();
          // Создаем новые частицы и запускаем анимацию в следующем кадре
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _lastSize != null) {
              _createFireworksWithSize(_lastSize!);
              Future.delayed(const Duration(milliseconds: 200), () {
                if (mounted) {
                  _controller.forward();
                }
              });
            }
          });
        }
      });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  void _updateParticles() {
    setState(() {
      final animationProgress = _controller.value;
      for (var particle in _particles) {
        particle.update(animationProgress);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        _lastSize = size;

        if (!_isInitialized && size.width > 0 && size.height > 0) {
          _isInitialized = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _particles.isEmpty) {
              _createFireworksWithSize(size);
            }
          });
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: FireworkPainter(
                _particles,
                isAnimating: _controller.isAnimating || _controller.value > 0,
                animationProgress: _controller.value,
                text: widget.text,
                textStyle: widget.textStyle,
              ),
              size: size,
            );
          },
        );
      },
    );
  }

  void _createFireworksWithSize(Size size) {
    // Защита от множественных вызовов при инициализации
    if (!_isInitialized && _particles.isNotEmpty) return;

    _particles.clear();

    // Создаем несколько фейерверков из разных точек
    for (int f = 0; f < widget.fireworkCount; f++) {
      // Случайная точка запуска фейерверка
      final startX = _random.nextDouble() * size.width;
      final startY = _random.nextDouble() * size.height * 0.5; // Верхняя половина экрана

      // Количество частиц на один фейерверк
      final particlesPerFirework = widget.particleCount ~/ widget.fireworkCount;
      final color = _colors[_random.nextInt(_colors.length)];

      for (int i = 0; i < particlesPerFirework; i++) {
        // Случайный угол разлета (360 градусов)
        final angle = _random.nextDouble() * 2 * math.pi;
        // Случайная скорость
        final speed = 0.01 + _random.nextDouble() * 4.0;
        // final speed = 0.7;

        _particles.add(FireworkParticle(
          position: Offset(startX, startY),
          velocity: Offset(
            math.cos(angle) * speed,
            math.sin(angle) * speed,
          ),
          color: color,
          life: 1.0,
          size: 2.0 + _random.nextDouble() * 4.0,
        ));
      }
    }

    setState(() {});
  }
}
