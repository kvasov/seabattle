package com.example.seabattle

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.RequiresPermission

class BluetoothScanner : BluetoothScannerApi {
    companion object {
        private const val TAG = "BluetoothScanner"
    }

    private val bluetoothLeScanner = BluetoothAdapter.getDefaultAdapter().bluetoothLeScanner

    private val handler = Handler(Looper.getMainLooper())

    @RequiresPermission(Manifest.permission.BLUETOOTH_SCAN)
    override fun startScanning(
        durationInMillis: Long,
        callback: (Result<List<BluetoothScanResult>>) -> Unit
    ) {
        Log.d(TAG, "🔍 startScanning: durationInMillis=$durationInMillis")
        val foundDevices = mutableListOf<BluetoothScanResult>()
        val deviceAddresses = mutableSetOf<String>()

        val leScanCallback: ScanCallback = object : ScanCallback() {
            @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
            override fun onScanResult(callbackType: Int, result: ScanResult) {
                super.onScanResult(callbackType, result)
                Log.d(
                    TAG,
                    "onScanResult: callbackType=$callbackType name=${result.device.name} address=${result.device.address}"
                )
                val deviceName = result.device.name
                if (deviceName.isNullOrBlank()) {
                    Log.d(TAG, "onScanResult: skipping device without name, address=${result.device.address}")
                    return
                }

                val address = result.device.address
                if (deviceAddresses.add(address)) {
                    val scanResult = BluetoothScanResult(
                        deviceName = deviceName,
                        deviceAddress = address
                    )
                    foundDevices.add(scanResult)
                    Log.d(TAG, "onScanResult: added new device $scanResult")
                } else {
                    Log.d(TAG, "onScanResult: duplicate device skipped, address=$address")
                }
            }
        }

        handler.postDelayed({
            Log.d(TAG, "🔍 stopScan: devicesFound=${foundDevices.size}")
            bluetoothLeScanner.stopScan(leScanCallback)
            Log.d(TAG, "🔍 stopScan: invoking callback with devices=$foundDevices")
            callback(Result.success(foundDevices))
        }, durationInMillis)

        Log.d(TAG, "🔍 startScan: initiating BLE scan")
        bluetoothLeScanner.startScan(leScanCallback)
    }
}