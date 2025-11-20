import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: 'seabattle',
    dartOut: 'lib/generated/api.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/example/seabattle/Api.kt',
    kotlinOptions: KotlinOptions(package: 'com.example.seabattle'),
    swiftOut: 'ios/Runner/Api.swift',
    swiftOptions: SwiftOptions(),
  ),
)

// Результат сканирования BLE устройств
class BluetoothScanResult {
  BluetoothScanResult({required this.deviceName, required this.deviceAddress});
  String deviceName;
  String deviceAddress;
}

// Результат подключения к BLE устройству
class ConnectionResult {
  ConnectionResult({required this.success, this.errorMessage});
  bool success;
  String? errorMessage;
}

// Данные акселерометра
class AccelerometerData {
  AccelerometerData({required this.x, required this.y, required this.z});
  double x;
  double y;
  double z;
}

// API для сканирования BLE устройств
@HostApi()
abstract class BluetoothScannerApi {
  @async
  List<BluetoothScanResult> startScanning(int durationInMillis);
}

// API для работы с BLE устройством (подключение, отправка, получение данных)
@HostApi()
abstract class BluetoothDeviceApi {
  // Подключиться к BLE устройству по адресу
  @async
  ConnectionResult connect(String deviceAddress);

  // Отключиться от устройства
  @async
  void disconnect();

  // Отправить целое число на устройство
  @async
  bool sendInt(int value);

  // Проверить статус подключения
  @async
  bool isConnected();
}

// Callback API для получения данных от устройства (от платформы к Dart)
@FlutterApi()
abstract class BluetoothDataCallback {
  // Вызывается когда получено целое число от устройства
  void onStringReceived(String value);

  // Вызывается при изменении статуса подключения
  void onConnectionStatusChanged(bool isConnected);

  // Вызывается при ошибке
  void onError(String errorMessage);
}


// API для работы с акселерометром
@HostApi()
abstract class AccelerometerApi {
  // Включить прием данных от акселерометра
  @async
  bool startAccelerometer();

  // Отключить прием данных от акселерометра
  @async
  bool stopAccelerometer();
}

// Callback API для получения данных от акселерометра (от платформы к Dart)
@FlutterApi()
abstract class AccelerometerDataCallback {
  // Вызывается когда получены данные от акселерометра
  void onAccelerometerDataReceived(AccelerometerData data);
}




// dart run pigeon --input pigeons/api.dart