package com.example.seabattle

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager

class Accelerometer(
    private val context: Context
) : AccelerometerApi, SensorEventListener {

    private val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private var accelerometerSensor: Sensor? = null
    private var callback: AccelerometerDataCallback? = null
    private var isRunning = false

    fun setCallback(cb: AccelerometerDataCallback) {
        callback = cb
    }

    // Реализация Pigeon API
    override fun startAccelerometer(callback: (Result<Boolean>) -> Unit) {
        if (isRunning) {
            callback(Result.success(true))
            return
        }

        accelerometerSensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        if (accelerometerSensor == null) {
            callback(Result.success(false))
            return
        }

        sensorManager.registerListener(this, accelerometerSensor, SensorManager.SENSOR_DELAY_GAME)
        isRunning = true
        callback(Result.success(true))
    }

    override fun stopAccelerometer(callback: (Result<Boolean>) -> Unit) {
        if (!isRunning) {
            callback(Result.success(true))
            return
        }

        sensorManager.unregisterListener(this)
        isRunning = false
        callback(Result.success(true))
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null || callback == null) return

        val data = AccelerometerData(
            x = event.values[0].toDouble(),
            y = event.values[1].toDouble(),
            z = event.values[2].toDouble()
        )

        callback?.onAccelerometerDataReceived(data) {
            // здесь можно игнорировать результат
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
}
