package com.esteana.noor

import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.webkit.JavascriptInterface
import android.webkit.WebView
import com.google.firebase.messaging.FirebaseMessaging

/**
 * جسر JavaScript ← → Android للويب الهجين (WebAppInterface).
 * يُربط بالـ WebView عبر addJavascriptInterface فيستدعيه الـ JS:
 * Android.vibrate() أو AndroidBridge.vibrate()، Android.getFCMToken()
 */
class WebAppInterface(
    private val webView: WebView
) {

    /**
     * استدعاء نظام الاهتزاز في الأندرويد (Haptic Feedback).
     * triggerVibration() و vibrate() يؤديان نفس التأثير.
     */
    @JavascriptInterface
    fun triggerVibration() {
        vibrateInternal()
    }

    @JavascriptInterface
    fun vibrate() {
        vibrateInternal()
    }

    private fun vibrateInternal() {
        webView.post {
            val context = webView.context
            val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                (context.getSystemService(android.content.Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager)
                    ?.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                context.getSystemService(android.content.Context.VIBRATOR_SERVICE) as? Vibrator
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && vibrator != null) {
                vibrator.vibrate(
                    VibrationEffect.createOneShot(50L, VibrationEffect.DEFAULT_AMPLITUDE)
                )
            }
        }
    }

    /**
     * طلب FCM Token وتمريره للويب عبر window.androidFCMTokenReceived(token).
     */
    @JavascriptInterface
    fun getFCMToken() {
        FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
            val token = if (task.isSuccessful) task.result ?: "" else ""
            val escaped = token.replace("\\", "\\\\").replace("'", "\\'").replace("\n", " ")
            webView.post {
                webView.evaluateJavascript(
                    "if(typeof window.androidFCMTokenReceived==='function'){window.androidFCMTokenReceived('$escaped');}",
                    null
                )
            }
        }
    }
}
