import Foundation
import CoreMotion
import Flutter

class Accelerometer: NSObject, AccelerometerApi {

    private let motionManager = CMMotionManager()
    private var callback: AccelerometerDataCallback? = nil
    private var isRunning = false

    func setCallback(callback: AccelerometerDataCallback) {
        self.callback = callback
    }

    func startAccelerometer(completion: @escaping (Result<Bool, Error>) -> Void) {
        if isRunning {
            completion(.success(true))
            return
        }

        guard motionManager.isAccelerometerAvailable else {
            completion(.success(false))
            return
        }

        motionManager.accelerometerUpdateInterval = 1.0 / 60.0

        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let data = data else { return }

            let acc = AccelerometerData(
                x: -data.acceleration.x,
                y: -data.acceleration.y,
                z: data.acceleration.z
            )

            self.callback?.onAccelerometerDataReceived(data: acc) { _ in
                // результат игнорируем, как на Android
            }
        }

        isRunning = true
        completion(.success(true))
    }

    func stopAccelerometer(completion: @escaping (Result<Bool, Error>) -> Void) {
        if !isRunning {
            completion(.success(true))
            return
        }

        motionManager.stopAccelerometerUpdates()
        isRunning = false
        completion(.success(true))
    }
}
