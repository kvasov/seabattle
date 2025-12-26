import 'package:flutter/material.dart';
import 'package:seabattle/core/constants/animations.dart';

/// Виджет линейки для перископа.
///
/// Отображает 2 анимированные линейки
class PeriscopeRuler extends StatefulWidget {
  const PeriscopeRuler({super.key});

  @override
  State<PeriscopeRuler> createState() => _PeriscopeRulerState();
}

class _PeriscopeRulerState extends State<PeriscopeRuler> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: periscopeRulerAnimationDuration,
    )..repeat(reverse: true);
    _controller.addListener(() {
      setState(() {
        _offset = _controller.value * periscopeRulerOffsetMultiplier;
      });
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
        return CustomPaint(
          painter: _PeriscopeRulerPainter(offset: _offset),
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );
      },
    );
  }
}

class _PeriscopeRulerPainter extends CustomPainter {
  final double offset;

  _PeriscopeRulerPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = .stroke
      ..strokeWidth = 1;

    // вертикальная линия основная
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), paint);
    for (int y = -100; y < size.height + 100; y += 6) {
      late double lineWidth;
      if (y % 10 == 0) {
        paint.color = Colors.white.withValues(alpha: 1);
        lineWidth = 10;
      } else {
        paint.color = Colors.white.withValues(alpha: 0.5);
        lineWidth = 4;
      }
      canvas.drawLine(
        Offset(size.width * 0.5 - lineWidth / 2, y.toDouble() + offset),
        Offset(size.width * 0.5 + lineWidth / 2, y.toDouble() + offset), paint);
    }

    // горизонтальная линия основная
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), paint);
    for (int x = -100; x < size.width + 100; x += 6) {
      late double lineWidth;
      if (x % 10 == 0) {
        paint.color = Colors.white.withValues(alpha: 1);
        lineWidth = 10;
      } else {
        paint.color = Colors.white.withValues(alpha: 0.5);
        lineWidth = 4;
      }
      canvas.drawLine(
        Offset(
          x.toDouble() + offset, size.height * 0.5 - lineWidth / 2
        ),
        Offset(
          x.toDouble() + offset, size.height * 0.5 + lineWidth / 2
        ), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is _PeriscopeRulerPainter) {
      return oldDelegate.offset != offset;
    }
    return true;
  }
}