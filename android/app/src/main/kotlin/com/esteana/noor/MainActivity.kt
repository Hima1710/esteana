package com.esteana.noor

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "com.esteana.noor/call_foreground"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "startCallForegroundService" -> {
                        applicationContext.startService(Intent(applicationContext, CallForegroundService::class.java))
                        result.success(null)
                    }
                    "stopCallForegroundService" -> {
                        applicationContext.stopService(Intent(applicationContext, CallForegroundService::class.java))
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("CALL_FOREGROUND", e.message, null)
            }
        }
    }
}
