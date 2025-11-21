import Flutter
import UIKit
import CoreBluetooth

@main
@objc class AppDelegate: FlutterAppDelegate {

  private var dataCallback: BluetoothDataCallback?
  private var deviceApi: BluetoothDeviceApiImpl?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let messenger = controller.binaryMessenger

      // Scanner
      BluetoothScannerApiSetup.setUp(
        binaryMessenger: messenger,
        api: BluetoothScanner()
      )

      // Data callback → Dart
      dataCallback = BluetoothDataCallback(binaryMessenger: messenger)

      // Device API (connect/send/receive)
      deviceApi = BluetoothDeviceApiImpl(dataCallback: dataCallback!)
      BluetoothDeviceApiSetup.setUp(
        binaryMessenger: messenger,
        api: deviceApi!
      )


      // ACCELEROMETER
      let accelerometerCallback = AccelerometerDataCallback(binaryMessenger: messenger)
      let accelerometerApiImpl = Accelerometer()
      accelerometerApiImpl.setCallback(callback: accelerometerCallback)
      AccelerometerApiSetup.setUp(
          binaryMessenger: messenger,
          api: accelerometerApiImpl
      )
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

class BluetoothScanner: NSObject, BluetoothScannerApi {
    private lazy var central: CBCentralManager = CBCentralManager(delegate: self, queue: .main)
    private var peripherals: [UUID: CBPeripheral] = [:]

    func startScanning(durationInMillis: Int64, completion: @escaping (Result<[BluetoothScanResult], any Error>) -> Void) {
        guard central.state == .poweredOn else {
            completion(.success([]))
            return
        }

        peripherals.removeAll()
        central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])

        let delay = max(0, Double(durationInMillis) / 1000.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            self.central.stopScan()
            let results = self.peripherals.values.map { p in
                BluetoothScanResult(
                    deviceName: p.name ?? "Unknown",
                    deviceAddress: p.identifier.uuidString
                )
            }.filter { !$0.deviceName.isEmpty && $0.deviceName != "Unknown" }
            completion(.success(results))
        }
    }
}

extension BluetoothScanner: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // В упрощённой версии ничего не делаем
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        peripherals[peripheral.identifier] = peripheral
    }
}
