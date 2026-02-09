package com.esteana.noor.di

import android.content.Context
import android.util.Log
import com.esteana.noor.BuildConfig
import com.esteana.noor.data.DeviceTokenBody
import com.esteana.noor.data.FcmApiService
import com.esteana.noor.data.SettingsApiService
import com.esteana.noor.data.SettingsRepository
import com.google.gson.GsonBuilder
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

private const val TAG = "Esteana_FCM"

fun createSettingsRepository(context: Context): SettingsRepository {
    val baseUrl = BuildConfig.API_BASE_URL
    val api = if (baseUrl.isNotBlank() && baseUrl != "https://your-api.example.com/") {
        Retrofit.Builder()
            .baseUrl(baseUrl)
            .addConverterFactory(GsonConverterFactory.create(GsonBuilder().create()))
            .build()
            .create(SettingsApiService::class.java)
    } else null
    return SettingsRepository(context, api)
}

/** إرسال FCM token إلى الداتابيز (جدول device_tokens) عبر Edge Function save-fcm-token. */
fun saveFcmTokenToBackend(context: Context, token: String) {
    val baseUrl = BuildConfig.API_BASE_URL
    val anonKey = BuildConfig.SUPABASE_ANON_KEY
    if (baseUrl.isBlank() || baseUrl == "https://your-api.example.com/") {
        Log.w(TAG, "لم يُحفظ FCM token: لم تُضبط SUPABASE_FUNCTIONS_URL في local.properties (مثال: https://xxxx.supabase.co/functions/v1/)")
        return
    }
    val clientBuilder = OkHttpClient.Builder()
        .connectTimeout(15, TimeUnit.SECONDS)
        .readTimeout(15, TimeUnit.SECONDS)
    if (anonKey.isNotBlank()) {
        clientBuilder.addInterceptor { chain ->
            chain.proceed(
                chain.request().newBuilder()
                    .addHeader("Authorization", "Bearer $anonKey")
                    .build()
            )
        }
    }
    val api = Retrofit.Builder()
        .baseUrl(baseUrl)
        .client(clientBuilder.build())
        .addConverterFactory(GsonConverterFactory.create(GsonBuilder().create()))
        .build()
        .create(FcmApiService::class.java)
    CoroutineScope(Dispatchers.IO).launch {
        try {
            val response = api.saveFcmToken(DeviceTokenBody(fcm_token = token))
            if (response.isSuccessful) {
                Log.d(TAG, "تم حفظ FCM token في الداتابيز بنجاح")
            } else {
                Log.e(TAG, "فشل حفظ FCM token: ${response.code()} ${response.message()}")
            }
        } catch (e: Exception) {
            Log.e(TAG, "خطأ عند إرسال FCM token للداتابيز", e)
        }
    }
}

/** إرسال إعدادات الإشعارات (تفعيل/إيقاف + التردد + التوقيت) مع التوكن إلى الداتابيز. */
fun saveDeviceNotificationPrefs(
    context: Context,
    token: String,
    notificationsEnabled: Boolean,
    frequencyHours: Int,
    timezoneOffset: Int = java.util.TimeZone.getDefault().rawOffset / 3600000
) {
    val baseUrl = BuildConfig.API_BASE_URL
    val anonKey = BuildConfig.SUPABASE_ANON_KEY
    if (baseUrl.isBlank() || baseUrl == "https://your-api.example.com/") return
    val clientBuilder = OkHttpClient.Builder().connectTimeout(15, TimeUnit.SECONDS).readTimeout(15, TimeUnit.SECONDS)
    if (anonKey.isNotBlank()) {
        clientBuilder.addInterceptor { chain ->
            chain.proceed(chain.request().newBuilder().addHeader("Authorization", "Bearer $anonKey").build())
        }
    }
    val api = Retrofit.Builder()
        .baseUrl(baseUrl)
        .client(clientBuilder.build())
        .addConverterFactory(GsonConverterFactory.create(GsonBuilder().create()))
        .build()
        .create(FcmApiService::class.java)
    CoroutineScope(Dispatchers.IO).launch {
        try {
            val body = DeviceTokenBody(
                fcm_token = token,
                notifications_enabled = notificationsEnabled,
                frequency_hours = frequencyHours,
                timezone_offset = timezoneOffset
            )
            val response = api.saveFcmToken(body)
            if (response.isSuccessful) Log.d(TAG, "تم تحديث إعدادات الإشعارات في الداتابيز")
            else Log.e(TAG, "فشل تحديث إعدادات الإشعارات: ${response.code()}")
        } catch (e: Exception) {
            Log.e(TAG, "خطأ عند تحديث إعدادات الإشعارات", e)
        }
    }
}
