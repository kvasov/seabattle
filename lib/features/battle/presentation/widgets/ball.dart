import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/accelerometer_provider.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';

class BallWidget extends ConsumerStatefulWidget {
  const BallWidget({super.key, required this.containerSize});

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

  static const double _ballSize = 20.0;
  static const double _friction = 0.35; // Коэффициент трения (0-1)
  static const double _accelerationFactor = 1.0; // Множитель ускорения
  static const double _maxVelocity = 4.0; // Максимальная скорость
  double get _maxPosition => widget.containerSize - _ballSize;

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
    _animationTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
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
      _velocityX += accelX * _accelerationFactor;
      _velocityY += accelY * _accelerationFactor;

      // Ограничиваем максимальную скорость
      _velocityX = _velocityX.clamp(-_maxVelocity, _maxVelocity);
      _velocityY = _velocityY.clamp(-_maxVelocity, _maxVelocity);
    }

    // Применяем трение (замедление)
    _velocityX *= _friction;
    _velocityY *= _friction;

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
        ref.read(battleViewModelProvider.notifier).handleBallTapDown((_ballX + _ballSize / 2).toInt(), (_ballY + _ballSize / 2).toInt());
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
                width: _ballSize,
                height: _ballSize,
                child: Container(
                  width: _ballSize,
                  height: _ballSize,
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