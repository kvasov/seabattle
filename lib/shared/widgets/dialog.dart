import 'package:flutter/material.dart';

class DialogPage extends Page<dynamic> {
  const DialogPage({super.key, required this.child});
  final Widget child;

  @override
  Route<dynamic> createRoute(BuildContext context) {
    return DialogRoute(
      context: context,
      builder: (context) => child,
      settings: this,
    );
  }
}