import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        duration: Duration(seconds: 15),
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
        final scaleText = 1.0 + 0.1 * (1 + math.sin(2 * math.pi * _controller.value));
        final scaleImage = 1.0 + 0.2 * (1 + math.sin(2 * math.pi * _controller.value));
        return Transform.scale(
          scale: scaleText,
          alignment: Alignment.center,
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
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
              final matrix = Matrix4.identity()
                ..translate(centerX, centerY)
                ..scale(baseScale)
                ..translate(-imageWidth / 2, -imageHeight / 2);

              return ImageShader(
                image!,
                TileMode.clamp,
                TileMode.clamp,
                matrix.storage,
              );
            },
            child: Text(
              'OTUS\nFOOD',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontVariations: [FontVariation('wght', 900)],
                fontSize: 95,
                height: 0.9
              ),
            ),
          ),
        );
      },
    );
  }
}