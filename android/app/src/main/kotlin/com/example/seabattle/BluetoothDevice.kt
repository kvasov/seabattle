package com.example.seabattle

import android.Manifest
import android.bluetooth.*
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import android.util.Log
import android.os.Handler
import android.os.Looper

class BluetoothDeviceApiImpl(
    private val context: Context,
    private val callback: BluetoothDataCallback
) : BluetoothDeviceApi {

    private val SERVICE_UUID =
        java.util.UUID.fromString("12345678-1234-1234-1234-1234567890ab")

    private val CHARACTERISTIC_UUID =
        java.util.UUID.fromString("abcd1234-abcd-1234-abcd-1234567890ab")

    private val bluetoothAdapter: BluetoothAdapter by lazy {
        val manager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        manager.adapter
    }

    private var gatt: BluetoothGatt? = null
    private var connected = false

    // Handler для главного потока
    private val mainHandler = Handler(Looper.getMainLooper())

    // Храним callback подключения, вызовем его после установления связи
    private var pendingConnectCallback: ((Result<ConnectionResult>) -> Unit)? = null

    override fun connect(deviceAddress: String, callback: (Result<ConnectionResult>) -> Unit) {
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.BLUETOOTH_CONNECT)
            != PackageManager.PERMISSION_GRANTED
        ) {
            callback(Result.failure(Exception("Missing BLUETOOTH_CONNECT permission")))
            return
        }

        val device = bluetoothAdapter.getRemoteDevice(deviceAddress)
            ?: run {
                callback(Result.failure(Exception("Device not found")))
                return
            }

        pendingConnectCallback = callback

        gatt = device.connectGatt(context, false, gattCallback)
    }

    override fun disconnect(callback: (Result<Unit>) -> Unit) {
        gatt?.disconnect()
        gatt?.close()
        gatt = null
        connected = false
        this.callback.onConnectionStatusChanged(false) { }
        callback(Result.success(Unit))
    }

    override fun sendInt(value: Long, callback: (Result<Boolean>) -> Unit) {
        val g = gatt
        if (g == null) {
            callback(Result.success(false))
            return
        }

        val characteristic = findWritableCharacteristic(g)
        if (characteristic == null) {
            callback(Result.success(false))
            return
        }

        // Отправляем int32 в бинарном виде (LE), как ESP32
        // val data = ByteArray(4)
        // val v = value.toInt()
        // data[0] = (v and 0xFF).toByte()
        // data[1] = ((v shr 8) and 0xFF).toByte()
        // data[2] = ((v shr 16) and 0xFF).toByte()
        // data[3] = ((v shr 24) and 0xFF).toByte()
        // characteristic.value = data

        val bytes = byteArrayOf(value.toByte())
        characteristic.value = bytes

        val success = g.writeCharacteristic(characteristic)
        callback(Result.success(success))
    }

    override fun isConnected(callback: (Result<Boolean>) -> Unit) {
        callback(Result.success(connected))
    }

    // -----------------------------------------------------
    // PRIVATE — GATT logic
    // -----------------------------------------------------

    private fun findWritableCharacteristic(g: BluetoothGatt): BluetoothGattCharacteristic? {
        val service = g.getService(SERVICE_UUID)
        if (service == null) {
            android.util.Log.e("💛 BluetoothDevice", "Service not found: $SERVICE_UUID")
            return null
        }

        val characteristic = service.getCharacteristic(CHARACTERISTIC_UUID)
        if (characteristic == null) {
            android.util.Log.e("💛 BluetoothDevice", "Characteristic not found: $CHARACTERISTIC_UUID")
            return null
        }

        val props = characteristic.properties
        val writable = props and (BluetoothGattCharacteristic.PROPERTY_WRITE or
                BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE)

        if (writable == 0) {
            android.util.Log.e("💛 BluetoothDevice", "Characteristic not writable")
            return null
        }

        return characteristic
    }

    // -----------------------------------------------------
    // GATT Callback
    // -----------------------------------------------------

    private val gattCallback = object : BluetoothGattCallback() {

        override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {

            if (newState == BluetoothProfile.STATE_CONNECTED) {
                // Log.d("💛 BLE", "Connected to GATT server")
                connected = true

                mainHandler.post {
                    callback.onConnectionStatusChanged(true) { }
                }

                // Запрашиваем сервисы
                gatt.discoverServices()

            } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {

                // Log.d("💛 BLE", "Disconnected")
                connected = false

                mainHandler.post {
                    callback.onConnectionStatusChanged(false) { }
                    pendingConnectCallback?.invoke(
                        Result.failure(Exception("Disconnected"))
                    )
                    pendingConnectCallback = null
                }
            }
        }

        override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {

            if (status == BluetoothGatt.GATT_SUCCESS) {

                // Log.d("💛 BLE", "Services discovered")

                subscribeToNotify(gatt)

                mainHandler.post {
                    pendingConnectCallback?.invoke(
                        Result.success(ConnectionResult(success = true))
                    )
                    pendingConnectCallback = null
                }

            } else {
                mainHandler.post {
                    pendingConnectCallback?.invoke(
                        Result.failure(Exception("Service discovery failed: $status"))
                    )
                    pendingConnectCallback = null
                }
            }
        }

        private fun subscribeToNotify(gatt: BluetoothGatt) {
            val service = gatt.getService(SERVICE_UUID) ?: return
            val characteristic = service.getCharacteristic(CHARACTERISTIC_UUID) ?: return

            if (characteristic.properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0) {
                gatt.setCharacteristicNotification(characteristic, true)
                val descriptor = characteristic.getDescriptor(
                    java.util.UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")
                )
                descriptor?.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                gatt.writeDescriptor(descriptor)
            }
        }

        override fun onCharacteristicChanged(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic
        ) {
            val bytes = characteristic.value

            // Выводим строку, отправленную с ESP32
            val stringValue = String(bytes, Charsets.UTF_8)
            // Log.d("💛 BLE", "Received from ESP32: $stringValue")

            // Выводим байты в hex формате для отладки
            val hexString = bytes.joinToString(" ") { "%02X".format(it) }
            // Log.d("💛 BLE", "Received bytes (hex): $hexString")

            // Вызываем callback на главном потоке
            mainHandler.post {
                // Отправляем строку напрямую из байтов
                callback.onStringReceived(stringValue) { }
            }
        }
    }
}
