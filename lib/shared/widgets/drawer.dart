import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/shared/providers/ble_provider.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    final bleState = ref.watch(bleNotifierProvider);

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
                  t.etc.bottomNavigationBar.home,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Морской бой',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
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
          if (bleState.value != null && bleState.value!.isConnected)
            ListTile(
              leading: Icon(Icons.bluetooth_connected, color: Colors.green),
              title: Text('🔗 Подключено'),
              subtitle: Text('BLE устройство подключено'),
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(bleNotifierProvider.notifier).disconnect();
                },
              ),
            )
          else
            ListTile(
              leading: Icon(Icons.bluetooth_disabled, color: Colors.grey),
              title: Text('BLE не подключен'),
              subtitle: Text('Нажмите для сканирования'),
              onTap: () {
                Navigator.pop(context);
                ref.read(bleNotifierProvider.notifier).startScanning();
              },
            ),
        ],
      ),
    );
  }
}