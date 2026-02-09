package com.esteana.noor

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

/**
 * ويدجت الشاشة الرئيسية — بطاقة العد التنازلي للصلاة القادمة.
 * يخزن **كل** صلوات اليوم من التطبيق؛ عند كل تحديث يحدد الصلاة القادمة من توقيت الجهاز
 * ويحوّل تلقائياً للصلاة التالية بعد انتهاء وقتها. عداد مستقل كل دقيقة عبر AlarmManager.
 *
 * لوج التحقق: adb logcat -s PrayerWidget
 */
class PrayerCountdownWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences,
    ) {
        val labelRemaining = widgetData.getString(KEY_LABEL_REMAINING, "المتبقي") ?: "المتبقي"
        val (nextPrayerDisplay, countdownHHmm) = findNextPrayerAndCountdown(widgetData.getString(KEY_PRAYERS_TODAY_JSON, null))

        Log.i(TAG, "onUpdate: widgetIds=${appWidgetIds.size} nextPrayer=$nextPrayerDisplay countdown=$countdownHHmm now=${System.currentTimeMillis()}")

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.prayer_countdown_widget)
            views.setTextViewText(R.id.widget_label_next, widgetData.getString(KEY_LABEL_NEXT, "الصلاة القادمة"))
            views.setTextViewText(R.id.widget_next_prayer, nextPrayerDisplay)
            views.setTextViewText(R.id.widget_date_gregorian, widgetData.getString(KEY_DATE_GREGORIAN, "--"))
            views.setTextViewText(R.id.widget_date_hijri, widgetData.getString(KEY_DATE_HIJRI, "--"))
            views.setTextViewText(R.id.widget_countdown, "$labelRemaining $countdownHHmm")
            appWidgetManager.updateAppWidget(widgetId, views)
        }

        scheduleNextUpdate(context, appWidgetIds)
    }

    /**
     * يقرأ مصفوفة الصلوات من JSON ويختار الأولى التي وقتها بعد الآن، ويحسب المتبقي (HH:mm).
     * إذا انتهت كل الصلوات يُرجع آخر صلاة و "00:00".
     */
    private fun findNextPrayerAndCountdown(json: String?): Pair<String, String> {
        if (json.isNullOrBlank()) return "--" to "--:--"
        val now = System.currentTimeMillis()
        try {
            val arr = JSONArray(json)
            for (i in 0 until arr.length()) {
                val obj = arr.getJSONObject(i)
                val nameAr = obj.optString("n", "")
                val t = obj.optLong("t", -1L)
                if (t <= 0) continue
                if (t > now) {
                    val display = "$nameAr — ${formatTimeHHmm(t)}"
                    val countdown = formatCountdownHHmm(t)
                    return display to countdown
                }
            }
            // كل الصلوات انتهت: اعرض آخر صلاة و 00:00
            if (arr.length() > 0) {
                val last = arr.getJSONObject(arr.length() - 1)
                val nameAr = last.optString("n", "")
                val t = last.optLong("t", -1L)
                return "$nameAr — ${formatTimeHHmm(t)}" to "00:00"
            }
        } catch (e: Exception) {
            Log.e(TAG, "findNextPrayerAndCountdown parse error", e)
        }
        return "--" to "--:--"
    }

    /** تنسيق وقت من epoch millis إلى HH:mm حسب توقيت الجهاز */
    private fun formatTimeHHmm(millis: Long): String {
        val cal = java.util.Calendar.getInstance()
        cal.timeInMillis = millis
        val h = cal.get(java.util.Calendar.HOUR_OF_DAY)
        val m = cal.get(java.util.Calendar.MINUTE)
        return "%02d:%02d".format(h, m)
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        Log.i(TAG, "onDisabled: تم إزالة الويدجت — إلغاء تنبيه العداد المستقل")
        cancelScheduledUpdate(context)
    }

    private fun scheduleNextUpdate(context: Context, appWidgetIds: IntArray) {
        if (appWidgetIds.isEmpty()) {
            Log.w(TAG, "scheduleNextUpdate: لا توجد ويدجتات، تخطي الجدولة")
            return
        }
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
        if (alarmManager == null) {
            Log.e(TAG, "scheduleNextUpdate: AlarmManager غير متوفر")
            return
        }
        val intent = Intent(context, PrayerCountdownWidgetProvider::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
        }
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0
        val pending = PendingIntent.getBroadcast(context, REQUEST_CODE_ALARM, intent, flags)
        val triggerAt = System.currentTimeMillis() + 60_000L
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            alarmManager.setAndAllowWhileIdle(AlarmManager.RTC, triggerAt, pending)
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC, triggerAt, pending)
        } else {
            @Suppress("DEPRECATION")
            alarmManager.set(AlarmManager.RTC, triggerAt, pending)
        }
        Log.i(TAG, "scheduleNextUpdate: تم جدولة التحديث التالي بعد 60 ثانية (triggerAt=$triggerAt)")
    }

    private fun cancelScheduledUpdate(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
        if (alarmManager == null) return
        val intent = Intent(context, PrayerCountdownWidgetProvider::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, IntArray(0))
        }
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0
        val pending = PendingIntent.getBroadcast(context, REQUEST_CODE_ALARM, intent, flags)
        alarmManager.cancel(pending)
        Log.i(TAG, "cancelScheduledUpdate: تم إلغاء التنبيه")
    }

    /** المتبقي حتى [nextAtMillis] بصيغة ساعات:دقائق (HH:mm) من توقيت الجهاز. */
    private fun formatCountdownHHmm(nextAtMillis: Long): String {
        if (nextAtMillis <= 0) return "--:--"
        val now = System.currentTimeMillis()
        var diffSeconds = (nextAtMillis - now) / 1000
        if (diffSeconds < 0) return "00:00"
        val h = (diffSeconds / 3600).toInt()
        diffSeconds %= 3600
        val m = (diffSeconds / 60).toInt()
        return "%02d:%02d".format(h, m)
    }

    companion object {
        private const val TAG = "PrayerWidget"
        private const val REQUEST_CODE_ALARM = 3001
        const val KEY_LABEL_NEXT = "widget_label_next"
        const val KEY_DATE_GREGORIAN = "widget_date_gregorian"
        const val KEY_DATE_HIJRI = "widget_date_hijri"
        const val KEY_LABEL_REMAINING = "widget_label_remaining"
        const val KEY_PRAYERS_TODAY_JSON = "widget_prayers_today_json"
    }
}
