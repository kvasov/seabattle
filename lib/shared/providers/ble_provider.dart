import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/generated/api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seabattle/features/ships_setup/presentation/viewmodels/setup_ships_viewmodel.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';


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
  final BleDevice? connectedDevice;
  final bool isConnected;
  final String error;
  final String? receivedString;

  BleState({
    required this.isScanning,
    required this.devices,
    required this.connectedDevice,
    required this.isConnected,
    required this.error,
    this.receivedString,
  });

  BleState copyWith({
    bool? isScanning,
    List<BluetoothScanResult>? devices,
    BleDevice? connectedDevice,
    bool? isConnected,
    String? error,
    String? receivedString,
  }) {
    return BleState(
      isScanning: isScanning ?? this.isScanning,
      devices: devices ?? this.devices,
      connectedDevice: connectedDevice ?? this.connectedDevice,
      isConnected: isConnected ?? this.isConnected,
      error: error ?? this.error,
      receivedString: receivedString ?? this.receivedString,
    );
  }
}

class BleNotifier extends AsyncNotifier<BleState> {
  static bool _callbackInitialized = false;

  @override
  BleState build() {
    // Настраиваем callback для получения строк от BLE устройства только один раз
    if (!_callbackInitialized) {
      BluetoothDataCallback.setUp(
        _BluetoothDataCallbackImpl(this),
      );
      _callbackInitialized = true;
    }

    return BleState(isScanning: false, devices: [], connectedDevice: null, isConnected: false, error: '');
  }

  final BluetoothScannerApi _bleScanner = BluetoothScannerApi();
  final BluetoothDeviceApi _bleDevice = BluetoothDeviceApi();
  bool isConnected = false;
  String? _lastReceivedValue;
  DateTime? _lastReceivedTime;

  Future<void> _onStringReceived(String value) async {
    final currentState = state.value;

    debugPrint('Received string from ESP32: $value');
    state = AsyncValue.loading();
    final now = DateTime.now();

    // Защита от дублирования: игнорируем повторные вызовы с тем же значением в течение 100ms
    if (_lastReceivedValue == value &&
        _lastReceivedTime != null &&
        now.difference(_lastReceivedTime!) < const Duration(milliseconds: 100)) {
      debugPrint('🔗 Ignoring duplicate message: $value');
      state = AsyncValue.data(currentState!);
      return;
    }

    _lastReceivedValue = value;
    _lastReceivedTime = now;

    // debugPrint('🔗 Received string from ESP32: $value');
    final newState = currentState!.copyWith(receivedString: value);
    state = AsyncValue.data(newState);
    if (ref.read(navigationProvider).last.name == '/setupShipsScreen') {
      ref.read(setupShipsViewModelProvider.notifier).handleESP32Message(value);
    } else if (ref.read(navigationProvider).last.name == '/battleScreen') {
      await ref.read(battleViewModelProvider.notifier).handleESP32Message(value);
    }
  }

  void _onConnectionStatusChanged(bool isConnected) {
    final currentState = state.value;
    debugPrint('🔗 Connection status changed: $isConnected');
    // TODO показать snackbar с сообщением о статусе соединения
    this.isConnected = isConnected;
    ref.read(setupShipsViewModelProvider.notifier).updateIsConnected(isConnected);
    state = AsyncValue.data(currentState!.copyWith(
      isConnected: isConnected,
      connectedDevice: null,
    ));
  }

  void _onError(String errorMessage) {
    final currentState = state.value;
    debugPrint('🔗 BLE Error: $errorMessage');
    state = AsyncValue.data(currentState!.copyWith(
      error: errorMessage,
      connectedDevice: null,
    ));
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

    final currentState = state.value;

    state = AsyncValue.loading();
    try {
      final devices = await _bleScanner.startScanning(3000);
      state = AsyncValue.data(currentState!.copyWith(
        isScanning: false,
        devices: devices,
        connectedDevice: null,
      ));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> connectToDevice( String name, String address) async {
    final currentState = state.value;

    state = AsyncValue.loading();

    try {
      final device = await _bleDevice.connect(address);
      if (device.success) {
        isConnected = true;
        state = AsyncValue.data(currentState!.copyWith(
          isConnected: isConnected,
          connectedDevice: BleDevice(name: name, address: address),
        ));
        debugPrint('🔗 Device connected successfully');
      } else {
        debugPrint('🔗 Device connection failed: ${device.errorMessage}');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> disconnect() async {
    final currentState = state.value;
    isConnected = false;
    try {
      await _bleDevice.disconnect();
      state = AsyncValue.data(currentState!.copyWith(
        isConnected: false,
        connectedDevice: null,
      ));
      debugPrint('🔗 Device disconnected successfully');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> sendInt(int value) async {
    if (!isConnected) {
      // debugPrint('🔗 Device is not connected');
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