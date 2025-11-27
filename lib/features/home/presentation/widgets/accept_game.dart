import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/home/presentation/styles/game_btn.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class AcceptGame extends ConsumerWidget {
  const AcceptGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.5 - 40;

    return SizedBox(
      width: buttonWidth,
      height: 140,
      child: ElevatedButton(
        style: gameBtnStyle,
        onPressed: () {
          ref.read(navigationProvider.notifier).pushScanQRScreen();
        },
        child: Column(
          children: [
            Icon(
              Icons.camera_alt,
              color: Colors.blue.shade400,
              size: 80,
            ),
            Text(
              t.home.joinGame,
              style: gameBtnTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}