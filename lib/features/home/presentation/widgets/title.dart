import 'package:flutter/material.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/app/styles/media.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Text(
      t.home.title,
      textAlign: .center,
      style: TextStyle(
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.5),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
        fontFamily: 'Roboto',
        fontVariations: [FontVariation('wght', 900)],
        fontSize: deviceType(context) == DeviceType.tablet ? 65 : 40,
        height: 1.2
      ),
    );
  }
}