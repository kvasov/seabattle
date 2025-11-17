import 'package:flutter/material.dart';

class CursorPainter extends StatelessWidget {
  const CursorPainter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.pink.shade400.withValues(alpha: 0.5),
          border: Border.all(
            color: Colors.pink.shade600,
            width: 2,
          ),
        ),
      ),
    );
  }
}