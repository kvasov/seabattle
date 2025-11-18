import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/ble_provider.dart';

class BLEWidget extends ConsumerWidget {
  const BLEWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleState = ref.watch(bleNotifierProvider);
    final bleNotifier = ref.read(bleNotifierProvider.notifier);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (!bleState.isLoading && bleState.value != null && bleState.value!.isConnected)
            ListTile(
              leading: Icon(Icons.bluetooth_connected, color: Colors.green),
              title: Text('Подключено'),
              subtitle: Text('${bleState.value?.connectedDevice?.name} (${bleState.value?.connectedDevice?.address})'),
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  bleNotifier.disconnect();
                },
              ),
            ),

          if (bleState.value != null && !bleState.value!.isConnected && !bleState.isLoading)
            ListTile(
              leading: Icon(Icons.bluetooth_disabled, color: Colors.grey),
              title: Text('BLE не подключен'),
              subtitle: Text('Нажмите для сканирования'),
              onTap: () {
                bleNotifier.startScanning();
              },
            ),

          if (bleState.isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          if (bleState.hasError)
            Text('Error: ${bleState.error}'),
          if (bleState.value != null && !bleState.value!.isConnected && !bleState.isLoading)
              for (var device in bleState.value?.devices ?? [])
                TextButton(onPressed: () {
                  bleNotifier.connectToDevice(device.deviceName, device.deviceAddress);
                }, child: Text('Device: ${device.deviceName} (${device.deviceAddress})')),
        ],
      ),
    );
  }
}