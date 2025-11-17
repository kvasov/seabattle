import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/shared/providers/ble_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    final bleState = ref.watch(bleNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  t.etc.bottomNavigationBar.home,
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontFamily: 'Roboto',
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    ref.read(navigationProvider.notifier).pushCreateGameScreen();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.qr_code),
                      Text(
                        t.home.proposeGame,
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(navigationProvider.notifier).pushScanQRScreen();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.camera_alt),
                      Text(
                        t.home.joinGame,
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(navigationProvider.notifier).pushSettingsScreen();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.settings),
                      Text(
                        t.home.settings,
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(bleNotifierProvider.notifier).startScanning();
                  },
                  child: Text('Scan'),
                ),
                if (bleState.isLoading)
                  const CircularProgressIndicator(),
                if (bleState.hasError)
                  Text('Error: ${bleState.error}'),
                if (bleState.value != null)
                  Text('Devices: ${bleState.value?.devices.length ?? 0}'),
                if (bleState.value != null)
                  if (bleState.value?.isConnected ?? false)
                    ...[
                      const Text('🔗 Connected'),
                      if (bleState.value?.receivedString != null)
                        Text('Received: ${bleState.value?.receivedString}'),
                      TextButton(onPressed: () {
                        ref.read(bleNotifierProvider.notifier).disconnect();
                      }, child: Text('Disconnect')),
                      TextButton(onPressed: () {
                        ref.read(bleNotifierProvider.notifier).sendInt(1);
                      }, child: Text('Send 1')),
                      Center(
                        child: Text('RC Enabled: ${ref.watch(bleNotifierProvider).value?.isConnected ?? false}'),
                      ),
                    ]
                  else
                    for (var device in bleState.value?.devices ?? [])
                      TextButton(onPressed: () {
                        ref.read(bleNotifierProvider.notifier).connectToDevice(device.deviceAddress);
                      }, child: Text('Device: ${device.deviceName} (${device.deviceAddress})')),

              ],
            ),
          ),
        ),
      ),
    );
  }
}