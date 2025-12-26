import 'package:flutter/material.dart';
import 'package:seabattle/core/constants/animations.dart';

/// Кастомная страница с настраиваемыми переходами.
///
/// Используется для создания страниц с fade-переходами и настраиваемыми
/// длительностями анимации.
class CustomPage extends Page<dynamic> {
  /// Создает кастомную страницу.
  ///
  /// [child] - виджет, отображаемый на странице.
  /// [name] - имя маршрута.
  /// [arguments] - аргументы маршрута.
  /// [transitionDuration] - длительность перехода вперед.
  /// [reverseTransitionDuration] - длительность обратного перехода.
  /// [curve] - кривая анимации перехода.
  const CustomPage({
    super.key,
    required this.child,
    required String name,
    required Map<String, dynamic>? arguments,
    this.transitionDuration = customPageTransitionDuration,
    this.reverseTransitionDuration = customPageTransitionDuration,
    this.curve = defaultPageTransitionCurve,
  }) : _name = name,
       _arguments = arguments;

  /// Виджет, отображаемый на странице.
  final Widget child;

  @override
  String get name => _name;
  final String _name;

  @override
  Map<String, dynamic>? get arguments => _arguments;
  final Map<String, dynamic>? _arguments;

  /// Длительность перехода.
  final Duration transitionDuration;

  /// Длительность обратного перехода.
  final Duration reverseTransitionDuration;

  /// Кривая анимации перехода.
  final Curve curve;

  @override
  Route<dynamic> createRoute(BuildContext context) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
      },
      settings: this,
    );
  }
}
