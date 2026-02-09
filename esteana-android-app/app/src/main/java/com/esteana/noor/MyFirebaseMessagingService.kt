package com.esteana.noor

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.esteana.noor.BuildConfig
import com.esteana.noor.di.saveFcmTokenToBackend
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {

    companion object {
        private const val TAG = "FCM_Service"
        const val CHANNEL_ID = "esteana_notifications"
        const val CHANNEL_NAME = "إشعارات إستعانة"
        private const val NOTIFICATION_ID_BASE = 1000
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        if (BuildConfig.DEBUG) Log.d(TAG, "Refreshed FCM token")
        saveFcmTokenToBackend(applicationContext, token)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        if (BuildConfig.DEBUG) Log.d(TAG, "From: ${remoteMessage.from}")

        val shown = remoteMessage.notification?.let { notification ->
            showNotification(
                title = notification.title ?: getString(R.string.app_name),
                body = notification.body ?: ""
            )
            true
        } ?: false

        if (!shown && remoteMessage.data.isNotEmpty()) {
            val title = remoteMessage.data["title"] ?: getString(R.string.app_name)
            val body = remoteMessage.data["body"] ?: remoteMessage.data["message"] ?: ""
            if (title.isNotEmpty() || body.isNotEmpty()) {
                showNotification(title, body)
            }
        }
    }

    private fun showNotification(title: String, body: String) {
        createNotificationChannel()

        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body).setBigContentTitle(title))
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setDefaults(NotificationCompat.DEFAULT_ALL)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .build()

        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(NOTIFICATION_ID_BASE + (System.currentTimeMillis() % 100000).toInt(), notification)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "قناة إشعارات تطبيق إستعانة"
                enableVibration(true)
                enableLights(true)
                setShowBadge(true)
            }
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }
    }
}
