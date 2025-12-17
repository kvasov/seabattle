import 'dart:math' as math;
import 'package:flutter/material.dart';

class BgWave extends StatefulWidget {
  const BgWave({super.key});

  @override
  State<BgWave> createState() => _BgWaveState();
}

class _BgWaveState extends State<BgWave> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _waveOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _controller.addListener(() {
      setState(() {
        _waveOffset += 0.02;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Функция для генерации волновой линии
  Path _createWavePath(double width, double height, double offset, int index) {
    final path = Path();
    // Настройки волны
    const double amplitude = 10;
    // длина волны
    const double k = 2 * math.pi / 300;
    // скорость колебаний
    const double omega = 1.5;

    for (double x = 0; x <= width; x += 5) {
      final y = height * 0.2 - index * 10 + amplitude * math.sin(k * (x + 100)) * math.cos(omega * offset)
        + amplitude * math.sin(k * (x + 200) /2) * math.cos(omega * offset /2)
        + amplitude * 1.5 * math.sin(k * x /12) * math.cos(omega * offset /17);
      if (x == 0) {
        path.moveTo(x, height - y);
      }
      path.lineTo(x, height - y);
    }

    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: _WavePainter(
            waveOffset: _waveOffset,
            createWavePath: _createWavePath,
          ),
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final double waveOffset;
  final Path Function(double width, double height, double offset, int index) createWavePath;

  _WavePainter({
    required this.waveOffset,
    required this.createWavePath,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Рисуем 3 волны с разными смещениями и цветами
    final waves = [
      {'offset': waveOffset, 'color': Color.fromARGB(128, 41, 123, 182), 'height': size.height},
      {'offset': waveOffset * 1.3, 'color': Color.fromARGB(205, 62, 159, 228), 'height': size.height},
      {'offset': waveOffset * 0.7, 'color': Color.fromARGB(175, 23, 86, 131), 'height': size.height},
    ];

    for (final entry in waves.asMap().entries) {
      final index = entry.key;
      final wave = entry.value;
      final wavePath = createWavePath(
        size.width,
        wave['height'] as double,
        wave['offset'] as double,
        index,
      );

      final alpha = 0.5 + 0.2 * math.sin((wave['offset'] as double) + 0.5);
      final alphaInt = (alpha * 255).toInt();
      final color = (wave['color'] as Color).withAlpha(alphaInt);

      final wavePaint = Paint()
        ..color = color
        ..style = .fill;

      canvas.drawPath(wavePath, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}