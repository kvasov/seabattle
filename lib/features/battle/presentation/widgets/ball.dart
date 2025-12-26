import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/core/constants/accelerometer_ball.dart';
import 'package:seabattle/shared/providers/accelerometer_provider.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';
import 'package:seabattle/core/constants/animations.dart';

/// Виджет шарика для управления выстрелом через акселерометр.
///
/// Отображает шарик, который движется по игровому полю в зависимости
/// от данных акселерометра. При нажатии на любое место поля соперника выполняется выстрел.
class BallWidget extends ConsumerStatefulWidget {
  /// Создает виджет шарика.
  ///
  /// [containerSize] - размер контейнера игрового поля.
  const BallWidget({super.key, required this.containerSize});

  /// Размер контейнера игрового поля.
  final double containerSize;

  @override
  ConsumerState<BallWidget> createState() => _BallWidgetState();
}

class _BallWidgetState extends ConsumerState<BallWidget> {
  // Текущая позиция шарика
  double _ballX = 0.0;
  double _ballY = 0.0;

  // Скорость шарика
  double _velocityX = 0.0;
  double _velocityY = 0.0;

  Timer? _animationTimer;

  double get _maxPosition => widget.containerSize - ballSize;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _animationTimer = Timer.periodic(ballAnimationFrameDuration, (timer) {
      if (mounted) {
        setState(() {
          _updateBallPosition();
        });
      }
    });
  }

  void _updateBallPosition() {
    final accelerometerBallState = ref.read(accelerometerNotifierProvider);
    final accelerometerData = accelerometerBallState.value;

    if (accelerometerData?.isReceivingData ?? false) {
      final accelX = -accelerometerData!.x;
      final accelY = accelerometerData.y;
      _velocityX += accelX * accelerationFactor;
      _velocityY += accelY * accelerationFactor;

      // Ограничиваем максимальную скорость
      _velocityX = _velocityX.clamp(-maxVelocity, maxVelocity);
      _velocityY = _velocityY.clamp(-maxVelocity, maxVelocity);
    }

    // Применяем трение (замедление)
    _velocityX *= friction;
    _velocityY *= friction;

    // Обновляем позицию на основе скорости
    _ballX += _velocityX;
    _ballY += _velocityY;

    // Ограничиваем позицию границами контейнера
    _ballX = _ballX.clamp(0.0, _maxPosition);
    _ballY = _ballY.clamp(0.0, _maxPosition);

    // Останавливаем движение, если скорость очень мала
    if (_velocityX.abs() < 0.1) _velocityX = 0.0;
    if (_velocityY.abs() < 0.1) _velocityY = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        ref.read(battleViewModelProvider.notifier).handleBallTapDown((_ballX + ballSize / 2).toInt(), (_ballY + ballSize / 2).toInt());
      },
      child: Container(
        width: widget.containerSize,
        height: widget.containerSize,
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              top: _ballY,
              left: _ballX,
              child: SizedBox(
                width: ballSize,
                height: ballSize,
                child: Container(
                  width: ballSize,
                  height: ballSize,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}