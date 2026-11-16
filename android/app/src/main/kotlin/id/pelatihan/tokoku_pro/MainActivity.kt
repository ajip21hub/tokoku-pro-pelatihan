package id.pelatihan.tokoku_pro

import android.content.Context
import android.os.BatteryManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Daftarkan implementasi native untuk API yang di-generate Pigeon.
        DeviceApi.setUp(flutterEngine.dartExecutor.binaryMessenger, DeviceApiImpl(this))
    }
}

/// Implementasi interface `DeviceApi` hasil generate Pigeon (DeviceApi.g.kt).
/// Type-safe: salah tipe/nama method = error compile, bukan crash runtime
/// seperti MethodChannel manual dengan string.
private class DeviceApiImpl(private val context: Context) : DeviceApi {
    override fun getDeviceInfo(): DeviceInfo {
        val battery = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return DeviceInfo(
            model = "${Build.MANUFACTURER} ${Build.MODEL}",
            osVersion = Build.VERSION.RELEASE,
            batteryLevel = battery.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY).toLong(),
        )
    }
}
