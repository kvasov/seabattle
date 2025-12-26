import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:seabattle/app/styles/media.dart';
import 'package:seabattle/core/constants/animations.dart';

/// Виджет стрелки, указывающей чей ход.
///
/// Отображает анимированную Lottie-стрелку зеленого цвета для своего хода
/// или красного цвета для хода противника.
class ArrowLottie extends StatelessWidget {
  /// Создает виджет стрелки хода.
  ///
  /// [isMyMove] - флаг, указывающий, мой ли это ход (true) или ход противника (false).
  const ArrowLottie({super.key, required this.isMyMove});

  /// Флаг, указывающий, мой ли это ход.
  final bool isMyMove;

  @override
  Widget build(BuildContext context) {
    final path = isMyMove ? 'assets/lottie/green.json' : 'assets/lottie/red.json';

    return AnimatedSwitcher(
      duration: lottieArrowAnimationDuration,
      child: isMyMove == true
        ? Transform.scale(
            key: const ValueKey('myMoveTrue'),
            scaleY: -1.0,
            child: _ArrowLottieWidget(path: path),
          )
        : Transform.scale(
            key: const ValueKey('myMoveFalse'),
            scaleY: 1.0,
            child: _ArrowLottieWidget(path: path),
          )
    );
  }
}


class _ArrowLottieWidget extends StatelessWidget {
  const _ArrowLottieWidget({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    final size = deviceType(context) == DeviceType.phone ? 40.0 : 60.0;
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.asset(
        path,
        fit: .contain,
        animate: true,
        repeat: true,
      ),
    );
  }
}