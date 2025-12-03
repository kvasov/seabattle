import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/home/presentation/styles/buttons.dart';
import 'package:seabattle/app/styles/theme_extension/simple_button.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class AcceptGameButton extends ConsumerWidget {
  const AcceptGameButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    return SizedBox(
      width: btnWidth(context),
      height: gameBtnHeight(context),
      child: ElevatedButton(
        style: gameBtnStyle(context),
        onPressed: () {
          ref.read(navigationProvider.notifier).pushScanQRScreen();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              color: Theme.of(context).extension<ButtonColors>()?.textColor ?? Colors.black,
              size: 80,
            ),
            Text(
              t.home.joinGame,
              textAlign: TextAlign.center,
              style: gameBtnTextStyle(context),
            ),
          ],
        ),
      ),
    );
  }
}