import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/generated/api.dart';

class AccelerometerBallState {
  final bool isReceivingData;
  final String error;
  final double x;
  final double y;
  final double z;
  final int ballX;
  final int ballY;

  AccelerometerBallState({
    required this.isReceivingData,
    required this.error,
    required this.x,
    required this.y,
    required this.z,
    required this.ballX,
    required this.ballY,
  });

  AccelerometerBallState copyWith({
    bool? isReceivingData,
    String? error,
    double? x,
    double? y,
    double? z,
    int? ballX,
    int? ballY,
  }) {
    return AccelerometerBallState(
      isReceivingData: isReceivingData ?? this.isReceivingData,
      error: error ?? this.error,
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      ballX: ballX ?? this.ballX,
      ballY: ballY ?? this.ballY,
    );
  }
}

class AccelerometerNotifier extends AsyncNotifier<AccelerometerBallState> {
  static bool _callbackInitialized = false;

  @override
  AccelerometerBallState build() {
    // Настраиваем callback для получения данных от акселерометра только один раз
    if (!_callbackInitialized) {
      AccelerometerDataCallback.setUp(
        _AccelerometerDataCallbackImpl(this),
      );
      _callbackInitialized = true;
    }

    return AccelerometerBallState(isReceivingData: false, error: '', x: 0, y: 0, z: 0, ballX: 0, ballY: 0);
  }

  final AccelerometerApi _accelerometer = AccelerometerApi();

  Future<void> _onAccelerometerDataReceived(AccelerometerData data) async {
    final currentState = state.value;
    state = AsyncValue.loading();

    // debugPrint('😘🤩🤩 Received accelerometer data: ${data.x}, ${data.y}, ${data.z}');
    final newState = currentState!.copyWith(isReceivingData: true, x: data.x, y: data.y, z: data.z);
    state = AsyncValue.data(newState);
  }

  Future<void> startReceivingData() async {
    // if (Platform.isAndroid) {
    //   final bluetooth = await Permission.bluetooth.request();
    //   log('bluetooth: ${bluetooth.toString()}');
    //   final location = await Permission.location.request();
    //   log('location: ${location.toString()}');
    //   final bluetoothScan = await Permission.bluetoothScan.request();
    //   log('bluetoothScan: ${bluetoothScan.toString()}');
    //   final bluetoothConnect = await Permission.bluetoothConnect.request();
    //   log('bluetoothConnect: ${bluetoothConnect.toString()}');
    //   final nearbyDevices = await Permission.nearbyWifiDevices.request();
    //   log('nearbyWifiDevices: ${nearbyDevices.toString()}');
    // } else if (Platform.isIOS) {
    //   final bluetooth = await Permission.bluetooth.request();
    //   log('bluetooth: ${bluetooth.toString()}');
    //   final locationWhenInUse = await Permission.locationWhenInUse.request();
    //   log('locationWhenInUse: ${locationWhenInUse.toString()}');
    // }

    final currentState = state.value;

    state = AsyncValue.loading();
    try {
      await _accelerometer.startAccelerometer();
      state = AsyncValue.data(currentState!.copyWith(
        isReceivingData: true,
      ));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> disconnect() async {
    final currentState = state.value;
    try {
      await _accelerometer.stopAccelerometer();
      state = AsyncValue.data(currentState!.copyWith(
        isReceivingData: false,
      ));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> toggleReceivingData() async {
    final currentState = state.value;
    if (currentState!.isReceivingData) {
      await disconnect();
    } else {
      await startReceivingData();
    }
  }
}

// Реализация callback для получения данных от акселерометра
class _AccelerometerDataCallbackImpl extends AccelerometerDataCallback {
  final AccelerometerNotifier notifier;

  _AccelerometerDataCallbackImpl(this.notifier);

  @override
  void onAccelerometerDataReceived(AccelerometerData data) {
    notifier._onAccelerometerDataReceived(data);
  }
}

final accelerometerNotifierProvider = AsyncNotifierProvider<AccelerometerNotifier, AccelerometerBallState>(() {
  return AccelerometerNotifier();
});