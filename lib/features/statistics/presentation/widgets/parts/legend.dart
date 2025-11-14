import 'package:flutter/material.dart';

class Legend extends StatelessWidget {
  final String title;
  final Color color;
  const Legend({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        SizedBox(width: 8),
        Text(title),
      ],
    );
  }
}