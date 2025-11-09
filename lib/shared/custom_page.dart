import 'package:flutter/material.dart';

class CustomPage extends Page<dynamic> {
  const CustomPage({
    super.key,
    required this.child,
    required String name,
    required Map<String, dynamic>? arguments,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  }) : _name = name,
       _arguments = arguments;
  final Widget child;

  @override
  String get name => _name;
  final String _name;

  @override
  Map<String, dynamic>? get arguments => _arguments;
  final Map<String, dynamic>? _arguments;

  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
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
