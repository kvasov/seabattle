import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlueAccent,
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Морской бой',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.qr_code, color: Colors.lightBlueAccent),
            title: Text(t.home.proposeGame),
            onTap: () {
              Navigator.pop(context);
              ref.read(navigationProvider.notifier).pushCreateGameScreen();
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt, color: Colors.lightBlueAccent),
            title: Text(t.home.joinGame),
            onTap: () {
              Navigator.pop(context);
              ref.read(navigationProvider.notifier).pushScanQRScreen();
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.lightBlueAccent),
            title: Text(t.home.settings),
            onTap: () {
              Navigator.pop(context);
              ref.read(navigationProvider.notifier).pushSettingsScreen();
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}