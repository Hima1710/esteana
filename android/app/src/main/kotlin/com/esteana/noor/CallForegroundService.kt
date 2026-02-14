package com.esteana.noor

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat

/**
 * خدمة أمامية نبدأها عند الدخول لمكالمة المقرأة الجماعية (Jitsi) حتى يظهر المؤشر الأخضر
 * للميكروفون والكاميرا في شريط الحالة (أندرويد 14+). مكتبة Jitsi قد تستدعي startForeground
 * بنوع الكاميرا فقط، لذلك نضيف هذه الخدمة مع نوع microphone|camera لضمان ظهور المؤشر.
 */
class CallForegroundService : Service() {

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        try {
            val notification = buildNotification()
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                val type = ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE
                ServiceCompat.startForeground(this, NOTIFICATION_ID, notification, type)
                Log.i(TAG, "CallForegroundService started with type MICROPHONE")
            } else {
                @Suppress("DEPRECATION")
                startForeground(NOTIFICATION_ID, notification)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start foreground", e)
            stopSelf()
        }
        return START_NOT_STICKY
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                getString(R.string.call_notification_channel_name),
                NotificationManager.IMPORTANCE_DEFAULT
            ).apply { setShowBadge(false) }
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    private fun buildNotification(): Notification {
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            packageManager.getLaunchIntentForPackage(packageName),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(getString(R.string.call_notification_title))
            .setContentText(getString(R.string.call_notification_text))
            .setSmallIcon(android.R.drawable.ic_btn_speak_now)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .build()
    }

    companion object {
        private const val TAG = "CallForegroundService"
        private const val CHANNEL_ID = "esteana_call_foreground"
        const val NOTIFICATION_ID = 9001
    }
}
