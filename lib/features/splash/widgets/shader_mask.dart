import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seabattle/core/constants/animations.dart';

/// Виджет с текстом, использующий шейдер-маску для анимации.
///
/// Отображает текст "МОРСКОЙ БОЙ" с анимированным фоновым изображением,
/// используя ShaderMask для создания эффекта масштабирования.
class TextMaskWidget extends StatefulWidget {
  const TextMaskWidget({super.key});

  @override
  _TextMaskWidgetState createState() => _TextMaskWidgetState();
}

class _TextMaskWidgetState extends State<TextMaskWidget> with SingleTickerProviderStateMixin {
  ui.Image? image;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _controller = AnimationController(
        vsync: this,
        duration: splashScreenDuration,
      )..repeat();
  }

  Future<void> _loadImage() async {
    final byteData = await rootBundle.load('assets/images/splash_bg.jpg');
    final codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      image = frame.image;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) return CircularProgressIndicator();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scaleText = 1.0 + splashTextScaleFactor * (1 + math.sin(2 * math.pi * _controller.value));
        final scaleImage = 1.0 + splashImageScaleFactor * (1 + math.sin(2 * math.pi * _controller.value));
        return Transform.scale(
          scale: scaleText,
          alignment: .center,
          child: ShaderMask(
            blendMode: .srcIn,
            shaderCallback: (bounds) {
              // Размеры области текста и изображения
              final double imageWidth = image!.width.toDouble();
              final double imageHeight = image!.height.toDouble();
              final double textWidth = bounds.width;
              final double textHeight = bounds.height;

              // Коэффициенты масштабирования по ширине и высоте
              final double scaleX = textWidth / imageWidth;
              final double scaleY = textHeight / imageHeight;

              // Выбираем максимальный масштаб, чтобы заполнить всё (cover)
              final double baseScale = scaleImage * (scaleX > scaleY ? scaleX : scaleY);

              // Центры текста и изображения
              final double centerX = textWidth / 2;
              final double centerY = textHeight / 2;

              // Трансформация
              final scaleMatrix = Matrix4.identity()..scaleByDouble(baseScale, baseScale, 1.0, 1.0);
              final matrix = Matrix4.translationValues(centerX, centerY, 0)
                * scaleMatrix
                * Matrix4.translationValues(-imageWidth / 2, -imageHeight / 2, 0);

              return ImageShader(
                image!,
                .clamp,
                .clamp,
                matrix.storage,
              );
            },
            child: Text(
              'МОРСКОЙ\nБОЙ',
              textAlign: .center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontVariations: [FontVariation('wght', 900)],
                fontSize: 65,
                height: 1.2
              ),
            ),
          ),
        );
      },
    );
  }
}