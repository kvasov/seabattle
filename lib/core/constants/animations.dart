import 'package:flutter/material.dart';

/// Длительность анимации волн на игровом поле.
const Duration waveAnimationDuration = Duration(seconds: 5);

/// Длительность анимации перемещения курсора.
const Duration cursorAnimationDuration = Duration(milliseconds: 300);

/// Длительность анимации перископа-линейки.
const Duration periscopeRulerAnimationDuration = Duration(seconds: 10);

/// Задержка перед переходом со splash экрана.
const Duration splashScreenDelay = Duration(milliseconds: 1000);

/// Длительность анимации на splash экране.
const Duration splashScreenDuration = Duration(seconds: 15);

/// Длительность перехода между страницами.
const Duration customPageTransitionDuration = Duration(milliseconds: 300);

/// Длительность анимации фоновых волн.
const Duration bgWaveAnimationDuration = Duration(seconds: 10);

/// Задержка между запусками фейерверка.
const Duration fireworkDelayDuration = Duration(milliseconds: 200);

/// Частота изменения состояния шарика (60 FPS).
const Duration ballAnimationFrameDuration = Duration(milliseconds: 16);

/// Длительность анимации фейерверка.
const Duration fireworkDuration = Duration(milliseconds: 2200);

/// Длительность анимации стрелок в Lottie.
const Duration lottieArrowAnimationDuration = Duration(milliseconds: 300);

/// Длительность анимации исчезновения корабля.
const Duration shipFadeOutDuration = Duration(milliseconds: 1000);

/// Задержка перед уничтожением корабля (в миллисекундах).
const int shipDestroyDelayDuration = 200;

/// Длительность анимации взрыва корабля (в миллисекундах).
const int shipExplosionDuration = 900;

/// Длительность анимации появления корабля (в миллисекундах).
const int shipFadeInDuration = 400;

/// Кривая анимации для переходов между страницами по умолчанию.
const Curve defaultPageTransitionCurve = Curves.easeInOut;

/// Кривая анимации для перемещения курсора.
const Curve cursorAnimationCurve = Curves.easeInOut;

/// Кривая анимации для волн.
const Curve waveAnimationCurve = Curves.linear;

/// Кривая анимации для fade-эффектов.
const Curve fadeAnimationCurve = Curves.easeIn;

/// Коэффициент масштабирования текста на splash экране.
const double splashTextScaleFactor = 0.1;

/// Коэффициент масштабирования изображения на splash экране.
const double splashImageScaleFactor = 0.2;

/// Коэффициент уменьшения масштаба корабля при взрыве.
const double deadShipScaleReduction = 0.4;

/// Базовый коэффициент масштабирования корабля.
const double scaleShip = 1.4;

/// Шаг смещения для анимации фоновых волн.
const double bgWaveOffsetStep = 0.02;

/// Множитель для расчета смещения перископа-линейки.
const double periscopeRulerOffsetMultiplier = 60.0;

/// Порог прозрачности для начала затемнения фейерверка.
const double fireworkAlphaThreshold = 0.7;

/// Диапазон затемнения фейерверка.
const double fireworkAlphaFadeRange = 0.3;

/// Коэффициент гравитации для частиц фейерверка.
const double fireworkGravityFactor = 0.05;

/// Порог прозрачности альфа-канала для обработки пикселей взрыва корабля.
const int deadShipAlphaThreshold = 50;