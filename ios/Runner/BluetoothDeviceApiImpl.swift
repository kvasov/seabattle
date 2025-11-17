import Foundation
import CoreBluetooth

class BluetoothDeviceApiImpl: NSObject, BluetoothDeviceApi {

    private let SERVICE_UUID = CBUUID(string: "12345678-1234-1234-1234-1234567890ab")
    private let CHARACTERISTIC_UUID = CBUUID(string: "abcd1234-abcd-1234-abcd-1234567890ab")

    private var central: CBCentralManager!
    private var peripheral: CBPeripheral?
    private var writeCharacteristic: CBCharacteristic?

    private var connectCallback: ((Result<ConnectionResult, Error>) -> Void)?
    private let dataCallback: BluetoothDataCallback

    private var connected = false

    init(dataCallback: BluetoothDataCallback) {
        self.dataCallback = dataCallback
        super.init()
        self.central = CBCentralManager(delegate: self, queue: .main)
    }

    // MARK: - Connect

    func connect(deviceAddress: String, completion: @escaping (Result<ConnectionResult, any Error>) -> Void) {
        guard central.state == .poweredOn else {
            completion(.failure(NSError(domain: "BLE", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bluetooth is OFF"])))
            return
        }

        guard let uuid = UUID(uuidString: deviceAddress) else {
            completion(.failure(NSError(domain: "BLE", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bad UUID"])))
            return
        }

        connectCallback = completion

        let peripherals = central.retrievePeripherals(withIdentifiers: [uuid])
        if let p = peripherals.first {
            peripheral = p
            peripheral?.delegate = self
            central.connect(p)
        } else {
            completion(.failure(NSError(domain: "BLE", code: -2, userInfo: [NSLocalizedDescriptionKey: "Peripheral not found"])))
        }
    }

    // MARK: - Disconnect

    func disconnect(completion: @escaping (Result<Void, any Error>) -> Void) {
        if let p = peripheral {
            central.cancelPeripheralConnection(p)
        }

        peripheral = nil
        connected = false

        DispatchQueue.main.async {
            self.dataCallback.onConnectionStatusChanged(isConnected: false) { _ in }
        }

        completion(.success(()))
    }

    // MARK: - Send Int

    func sendInt(value: Int64, completion: @escaping (Result<Bool, any Error>) -> Void) {
        guard connected, let characteristic = writeCharacteristic else {
            completion(.success(false))
            return
        }

        let byte = UInt8(value & 0xFF)
        let data = Data([byte])

        peripheral?.writeValue(data, for: characteristic, type: .withResponse)
        completion(.success(true))
    }

    // MARK: - isConnected

    func isConnected(completion: @escaping (Result<Bool, any Error>) -> Void) {
        completion(.success(connected))
    }
}



extension BluetoothDeviceApiImpl: CBCentralManagerDelegate, CBPeripheralDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Можно добавить логи при необходимости
    }

    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {

        connected = true

        DispatchQueue.main.async {
            self.dataCallback.onConnectionStatusChanged(isConnected: true) { _ in }
        }

        peripheral.discoverServices([SERVICE_UUID])
    }

    func centralManager(_ central: CBCentralManager,
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?) {

        connectCallback?(.failure(error ?? NSError(domain: "BLE", code: -1)))
        connectCallback = nil
    }

    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {

        connected = false

        DispatchQueue.main.async {
            self.dataCallback.onConnectionStatusChanged(isConnected: false) { _ in }
        }
    }

    // MARK: - Discover services

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            connectCallback?(.failure(error!))
            connectCallback = nil
            return
        }

        guard let service = peripheral.services?.first(where: { $0.uuid == SERVICE_UUID }) else {
            connectCallback?(.failure(NSError(domain: "BLE", code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Service not found"])))
            connectCallback = nil
            return
        }

        peripheral.discoverCharacteristics([CHARACTERISTIC_UUID], for: service)
    }

    // MARK: - Discover characteristics

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {

        guard error == nil else {
            connectCallback?(.failure(error!))
            connectCallback = nil
            return
        }

        guard let characteristic = service.characteristics?.first(where: { $0.uuid == CHARACTERISTIC_UUID }) else {
            connectCallback?(.failure(NSError(domain: "BLE", code: -4,
                userInfo: [NSLocalizedDescriptionKey: "Characteristic not found"])))
            connectCallback = nil
            return
        }

        writeCharacteristic = characteristic

        if characteristic.properties.contains(.notify) {
            peripheral.setNotifyValue(true, for: characteristic)
        }

        connectCallback?(.success(ConnectionResult(success: true)))
        connectCallback = nil
    }

    // MARK: - Receive notify

    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {

        guard error == nil else { return }
        guard let value = characteristic.value else { return }

        let string = String(data: value, encoding: .utf8) ?? ""

        print("📥 iOS received: \(string)")
        print("📥 HEX: \(value.map { String(format: "%02X", $0) }.joined(separator: " "))")

        DispatchQueue.main.async {
            self.dataCallback.onStringReceived(value: string) { _ in }
        }
    }
}
