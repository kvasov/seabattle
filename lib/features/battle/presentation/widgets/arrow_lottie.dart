import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ArrowLottie extends StatelessWidget {
  const ArrowLottie({super.key, required this.isMyMove});
  final bool isMyMove;

  @override
  Widget build(BuildContext context) {
    final path = isMyMove ? 'assets/lottie/green.json' : 'assets/lottie/red.json';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
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
    return SizedBox(
      width: 40,
      height: 40,
      child: Lottie.asset(
        path,
        fit: BoxFit.contain,
        animate: true,
        repeat: true,
      ),
    );
  }
}