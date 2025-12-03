import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/app/styles/media.dart';
import 'package:seabattle/app/styles/theme_extension/simple_button.dart';
import 'package:seabattle/features/home/presentation/styles/buttons.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        style: settingsBtnStyle(context),
        onPressed: () {
          ref.read(navigationProvider.notifier).pushSettingsScreen();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.settings, color: Theme.of(context).extension<ButtonColors>()?.textColor ?? Colors.black, size: 20),
            SizedBox(width: 5),
            Text(
              t.home.settings,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).extension<ButtonColors>()?.textColor,
                fontSize: deviceType(context) == DeviceType.tablet ? 20 : 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}