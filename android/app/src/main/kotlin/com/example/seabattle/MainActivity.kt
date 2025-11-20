package com.example.seabattle

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        BluetoothScannerApi.setUp(flutterEngine.dartExecutor.binaryMessenger, BluetoothScanner())

        val dataCallback = BluetoothDataCallback(flutterEngine.dartExecutor.binaryMessenger)
        val deviceApi = BluetoothDeviceApiImpl(this, dataCallback)
        BluetoothDeviceApi.setUp(flutterEngine.dartExecutor.binaryMessenger, deviceApi)

        val accelerometerCallback = AccelerometerDataCallback(flutterEngine.dartExecutor.binaryMessenger)
        val accelerometerApiImpl = Accelerometer(this)
        accelerometerApiImpl.setCallback(accelerometerCallback)

        AccelerometerApi.setUp(flutterEngine.dartExecutor.binaryMessenger, accelerometerApiImpl)
        // AccelerometerDataCallback.setUp(...) → удалить
    }
}
