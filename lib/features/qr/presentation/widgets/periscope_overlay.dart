import 'package:flutter/material.dart';

class PeriscopeOverlay extends StatelessWidget {
  const PeriscopeOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipPath(
          clipper: _CircleClipper(),
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: Colors.black.withValues(alpha: 0.5),
          ),
        );
      },
    );
  }
}

class _CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      // Добавляем весь прямоугольник
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      // Вычитаем круг (используем fillType для создания "дырки")
      ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2.5, // Радиус круга
      ))
      ..fillType = PathFillType.evenOdd; // Это создает "дырку" в пути

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}