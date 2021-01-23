package com.faken.memory.memory_plugin

import android.app.ActivityManager
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.util.*

/** MemoryPlugin */
class MemoryPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "memory_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "getMemoryInfo" -> {
                val actManager: ActivityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                val memoryInfo: ActivityManager.MemoryInfo = ActivityManager.MemoryInfo()
                actManager.getMemoryInfo(memoryInfo)
                val totalMemory = memoryInfo.totalMem
                val availableMemory = memoryInfo.availMem
                val usedMemory = totalMemory - availableMemory
                val usedPercent = usedMemory/totalMemory
                result.success("TotalMemory: ${bytesToHuman(totalMemory)}, UsedMemory: ${bytesToHuman(usedMemory)}, " +
                        "AvailableMemory: ${bytesToHuman(availableMemory)}, UsedPercentage: $usedPercent")
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun floatForm(d: Double): String {
        return String.format(Locale.US, "%.2f", d)
    }

    private fun bytesToHuman(size: Long): String? {
        val Kb: Long = 1024
        val Mb = Kb * 1024
        val Gb = Mb * 1024
        val Tb = Gb * 1024
        val Pb = Tb * 1024
        val Eb = Pb * 1024
        if (size < Kb) return floatForm(size.toDouble()) + " byte"
        if (size in Kb until Mb) return floatForm(size.toDouble() / Kb) + " KB"
        if (size in Mb until Gb) return floatForm(size.toDouble() / Mb) + " MB"
        if (size in Gb until Tb) return floatForm(size.toDouble() / Gb) + " GB"
        if (size in Tb until Pb) return floatForm(size.toDouble() / Tb) + " TB"
        if (size in Pb until Eb) return floatForm(size.toDouble() / Pb) + " Pb"
        return if (size >= Eb) floatForm(size.toDouble() / Eb) + " Eb" else "0"
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
