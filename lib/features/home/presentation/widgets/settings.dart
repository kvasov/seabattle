import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/home/presentation/styles/game_btn.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    return SizedBox(
      width: 200,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          ref.read(navigationProvider.notifier).pushSettingsScreen();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.settings, color: Colors.blue.shade400, size: 20),
            SizedBox(width: 5),
            Text(
              t.home.settings,
              style: gameBtnTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}