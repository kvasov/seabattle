import 'dart:math';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/core/constants/ships.dart';
import 'package:seabattle/shared/entities/ship.dart';
import 'package:seabattle/shared/providers/ui_provider.dart';
import 'package:seabattle/shared/entities/pixel_particle.dart';
import 'package:seabattle/utils/pixel_painter.dart';

class DeadShipWidget extends ConsumerStatefulWidget {
  const DeadShipWidget({super.key, required this.ship, required this.gridSize});

  final Ship ship;
  final int gridSize;

  @override
  ConsumerState<DeadShipWidget> createState() => _DeadShipWidgetState();
}

class _DeadShipWidgetState extends ConsumerState<DeadShipWidget> with TickerProviderStateMixin {
  final GlobalKey _repaintKey = GlobalKey();
  late AnimationController _fadeOutController;
  late Animation<double> _fadeOutAnimation;
  late AnimationController _fadeInController;
  late AnimationController _explosionController;
  late Animation<double> _fadeAnimation;
  List<PixelParticle> _particles = [];
  bool _isExploding = false;
  Size? _widgetSize;

  @override
  void initState() {
    super.initState();

    // Контроллер для плавного появления картинки
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: shipFadeInDuration),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeInController, curve: Curves.easeIn),
    );

    // Контроллер для плавного исчезновения подложки
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeIn),
    );

    // Контроллер для взрыва
    _explosionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: shipExplosionDuration),
    )..addListener(() {
        setState(() {
          for (var p in _particles) {
            p.update();
          }
        });
      })
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isExploding = false;
      }
    });

    // Запускаем появление картинки
    _fadeInController.forward();

    // После завершения появления запускаем взрыв
    _fadeInController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _explode();
      }
    });
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _explosionController.dispose();
    _particles.clear();
    super.dispose();
  }

  Future<void> _explode() async {
    final boundary = _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;

    // Ждём конца текущего фрейма
    await Future.delayed(Duration.zero);
    await WidgetsBinding.instance.endOfFrame;

    // Получаем изображение и байты
    final image = await boundary.toImage(pixelRatio: 1.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return;
    final bytes = byteData.buffer.asUint8List();

    // Получаем реальный размер виджета
    final box = _repaintKey.currentContext?.findRenderObject() as RenderBox?;
    _widgetSize = box?.size;

    final width = image.width;
    final height = image.height;
    // Пикселей не так много, берем каждый.
    // Если виджет большой, то берем каждый 2-й (3, 4, 5...)  пиксель.
    const pixelSize = 1;
    final newParticles = <PixelParticle>[];

    for (int y = 0; y < height; y += pixelSize) {
      for (int x = 0; x < width; x += pixelSize) {
        final index = (y * width + x) * 4;
        final r = bytes[index];
        final g = bytes[index + 1];
        final b = bytes[index + 2];
        final a = bytes[index + 3];

        if (a > 50) {
          final color = Color.fromARGB(a, r, g, b);
          // Случайная скорость по X и Y
          final vx = (Random().nextDouble() - 0.5) * 2;
          final vy = (Random().nextDouble() - 1.0) * 2;

          newParticles.add(PixelParticle(
            position: Offset(x.toDouble(), y.toDouble()),
            velocity: Offset(vx, vy),
            color: color,
          ));
        }
      }
    }

    setState(() {
      _particles = newParticles;
      _isExploding = true;
    });

    _explosionController.forward(from: 0);
  }


  @override
  Widget build(BuildContext context) {
    ref.read(cellSizeProvider.notifier).init(context);
    final cellSize = ref.watch(cellSizeProvider);

    return Container(
        width: cellSize * widget.gridSize,
        height: cellSize * widget.gridSize,
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              top: widget.ship.y * cellSize,
              left: widget.ship.x * cellSize,
              child: Container(
                child:
                  _isExploding && _widgetSize != null
                    ? SizedBox(
                        width: _widgetSize!.width,
                        height: _widgetSize!.height,
                        child: AnimatedBuilder(
                          animation: _explosionController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: PixelPainter(_particles, animationProgress: _explosionController.value),
                            );
                          },
                        ),
                      )
                    : Stack(
                      children: [
                        AnimatedBuilder(
                          animation: _fadeOutAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeOutAnimation.value,
                              child: Container(
                                color: Colors.blue.shade50,
                                width: widget.ship.orientation == ShipOrientation.horizontal ? widget.ship.size * cellSize : cellSize,
                                height: widget.ship.orientation == ShipOrientation.vertical ? widget.ship.size * cellSize : cellSize,
                              ),
                            );
                          },
                        ),
                        RepaintBoundary(
                          key: _repaintKey,
                          child: AnimatedBuilder(
                            animation: _fadeAnimation,
                            builder: (context, child) {
                              final scale = 1.4 - (0.4 * _fadeAnimation.value);
                              final fileName = widget.ship.orientation == ShipOrientation.horizontal ? 'x${widget.ship.size}.png' : 'x${widget.ship.size}_v.png';
                              return Opacity(
                                opacity: _fadeAnimation.value,
                                child: Transform.scale(
                                  scale: scale,
                                  alignment: .center,
                                  child: SizedBox(
                                    width: widget.ship.orientation == ShipOrientation.horizontal ? widget.ship.size * cellSize : cellSize,
                                    height: widget.ship.orientation == ShipOrientation.vertical ? widget.ship.size * cellSize : cellSize,
                                    child: Image.asset('assets/images/ships/$fileName'),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
              ),
            ),
          ],
        ),
    );
  }
}