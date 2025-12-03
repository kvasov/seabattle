import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/home/presentation/styles/buttons.dart';
import 'package:seabattle/app/styles/theme_extension/simple_button.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class CreateGameButton extends ConsumerWidget {
  const CreateGameButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    return SizedBox(
      width: btnWidth(context),
      height: gameBtnHeight(context),
      child: ElevatedButton(
        style: gameBtnStyle(context),
        onPressed: () {
          ref.read(navigationProvider.notifier).pushCreateGameScreen();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code,
              color: Theme.of(context).extension<ButtonColors>()?.textColor,
              size: 80,
            ),
            Text(
              t.home.proposeGame,
              textAlign: TextAlign.center,
              style: gameBtnTextStyle(context),
            ),
          ],
        ),
      ),
    );
  }
}