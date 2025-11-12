import 'package:flutter/material.dart';

class DialogPage extends Page<dynamic> {
  const DialogPage({
    super.key,
    required this.child,
    this.barrierDismissible = true,
  });

  final Widget child;
  final bool barrierDismissible;

  @override
  Route<dynamic> createRoute(BuildContext context) {
    return DialogRoute(
      context: context,
      builder: (context) => child,
      settings: this,
      barrierDismissible: barrierDismissible,
    );
  }
}