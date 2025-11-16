import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/generated/api.dart';
import 'package:permission_handler/permission_handler.dart';


class BleDevice {
  final String name;
  final String address;

  BleDevice({
    required this.name,
    required this.address,
  });
}

class BleState {
  final bool isScanning;
  final List<BluetoothScanResult> devices;
  final bool isConnected;
  final String error;
  final String? receivedString;

  BleState({
    required this.isScanning,
    required this.devices,
    required this.isConnected,
    required this.error,
    this.receivedString,
  });

  BleState copyWith({
    bool? isScanning,
    List<BluetoothScanResult>? devices,
    bool? isConnected,
    String? error,
    String? receivedString,
  }) {
    return BleState(
      isScanning: isScanning ?? this.isScanning,
      devices: devices ?? this.devices,
      isConnected: isConnected ?? this.isConnected,
      error: error ?? this.error,
      receivedString: receivedString ?? this.receivedString,
    );
  }
}

class BleNotifier extends AsyncNotifier<BleState> {
  @override
  BleState build() {
    // Настраиваем callback для получения строк от BLE устройства
    BluetoothDataCallback.setUp(
      _BluetoothDataCallbackImpl(this),
    );

    return BleState(isScanning: false, devices: [], isConnected: false, error: '');
  }

  final BluetoothScannerApi _bleScanner = BluetoothScannerApi();
  final BluetoothDeviceApi _bleDevice = BluetoothDeviceApi();
  bool isConnected = false;

  void _onStringReceived(String value) {
    debugPrint('🔗 Received string from ESP32: $value');
    state = AsyncValue.data(
      state.value?.copyWith(receivedString: value) ??
          BleState(isScanning: false, devices: [], isConnected: isConnected, error: '', receivedString: value),
    );
  }

  void _onConnectionStatusChanged(bool isConnected) {
    debugPrint('🔗 Connection status changed: $isConnected');
    // TODO показать snackbar с сообщением о статусе соединения
    this.isConnected = isConnected;
    state = AsyncValue.data(
      state.value?.copyWith(isConnected: isConnected) ??
          BleState(isScanning: false, devices: [], isConnected: isConnected, error: ''),
    );
  }

  void _onError(String errorMessage) {
    debugPrint('🔗 BLE Error: $errorMessage');
    state = AsyncValue.data(
      state.value?.copyWith(error: errorMessage) ??
          BleState(isScanning: false, devices: [], isConnected: isConnected, error: errorMessage),
    );
  }

  Future<void> startScanning() async {
    if (Platform.isAndroid) {
      final bluetooth = await Permission.bluetooth.request();
      log('bluetooth: ${bluetooth.toString()}');
      final location = await Permission.location.request();
      log('location: ${location.toString()}');
      final bluetoothScan = await Permission.bluetoothScan.request();
      log('bluetoothScan: ${bluetoothScan.toString()}');
      final bluetoothConnect = await Permission.bluetoothConnect.request();
      log('bluetoothConnect: ${bluetoothConnect.toString()}');
      final nearbyDevices = await Permission.nearbyWifiDevices.request();
      log('nearbyWifiDevices: ${nearbyDevices.toString()}');
    } else if (Platform.isIOS) {
      final bluetooth = await Permission.bluetooth.request();
      log('bluetooth: ${bluetooth.toString()}');
      final locationWhenInUse = await Permission.locationWhenInUse.request();
      log('locationWhenInUse: ${locationWhenInUse.toString()}');
    }

    state = AsyncValue.loading();
    try {
      final devices = await _bleScanner.startScanning(5000);
      state = AsyncValue.data(BleState(isScanning: false, devices: devices, isConnected: isConnected, error: ''));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> connectToDevice(String address) async {
    // state = AsyncValue.loading();
    try {
      final device = await _bleDevice.connect(address);
      if (device.success) {
        isConnected = true;
        state = AsyncValue.data(BleState(isScanning: false, devices: [], isConnected: isConnected, error: ''));
        debugPrint('🔗 Device connected successfully');
      } else {
        debugPrint('🔗 Device connection failed: ${device.errorMessage}');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> disconnect() async {
    isConnected = false;
    try {
      await _bleDevice.disconnect();
      state = AsyncValue.data(BleState(isScanning: false, devices: [], isConnected: isConnected, error: ''));
      debugPrint('🔗 Device disconnected successfully');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> sendInt(int value) async {
    if (!isConnected) {
      debugPrint('🔗 Device is not connected');
      return;
    }
    try {
      debugPrint('🔗 Attempting to send int: $value');
      final result = await _bleDevice.sendInt(value);
      if (result) {
        debugPrint('🔗 Int sent successfully');
      } else {
        debugPrint('🔗 Int sending failed - возможные причины: GATT null, характеристика не найдена, или writeCharacteristic вернул false');
      }
    } catch (e) {
      debugPrint('🔗 Error sending int: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Реализация callback для получения данных от BLE устройства
class _BluetoothDataCallbackImpl extends BluetoothDataCallback {
  final BleNotifier notifier;

  _BluetoothDataCallbackImpl(this.notifier);

  @override
  void onStringReceived(String value) {
    notifier._onStringReceived(value);
  }

  @override
  void onConnectionStatusChanged(bool isConnected) {
    notifier._onConnectionStatusChanged(isConnected);
  }

  @override
  void onError(String errorMessage) {
    notifier._onError(errorMessage);
  }
}

final bleNotifierProvider = AsyncNotifierProvider<BleNotifier, BleState>(() {
  return BleNotifier();
});