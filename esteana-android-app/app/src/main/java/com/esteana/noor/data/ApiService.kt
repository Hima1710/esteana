package com.esteana.noor.data

import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.Query

/**
 * واجهة استدعاء الـ API (Supabase Edge Function get-noor-data).
 * المعاملات: Lat, Lon, Age, Job, Gender, Time + age_group, target_occupation.
 * الرد يتضمن المحتوى الإيماني والمرجع وتوقيتات الصلاة.
 */
interface SettingsApiService {

    /** جلب المحتوى وتوقيتات الصلاة والتاريخ الهجري (إحداثيات اختيارية لأوقات الصلاة حسب الموقع). */
    @GET("get-noor-data")
    suspend fun getNoorData(
        @Query("lat") lat: Double = 30.04,
        @Query("lon") lon: Double = 31.23
    ): NoorDataResponse

    /** إرسال الإعدادات والحصول على المحتوى وتوقيتات الصلاة (Edge Function get-noor-data). */
    @POST("get-noor-data")
    suspend fun sendSettings(@Body body: SettingsApiRequest): NoorDataResponse
}

/**
 * نموذج رد Edge Function get-noor-data.
 */
data class NoorDataResponse(
    val status: String? = null,
    val content: ContentItem? = null,
    val timings: Map<String, String>? = null,
    val hijri_date: HijriDateResponse? = null,
    val meta: Map<String, Any?>? = null
)

/** التاريخ الهجري كما يرجعه الـ API (Aladhan مثلاً). */
data class HijriDateResponse(
    val date: String? = null,
    val day: String? = null,
    val weekday: HijriWeekday? = null,
    val month: HijriMonth? = null,
    val year: String? = null
)

data class HijriWeekday(val en: String? = null, val ar: String? = null)
data class HijriMonth(val number: Int? = null, val en: String? = null, val ar: String? = null, val days: Int? = null)

data class ContentItem(
    val content: String? = null,
    val reference: String? = null,
    val title: String? = null,
    val content_type: String? = null
)

/** جسم طلب save-fcm-token (توكن + إعدادات الإشعارات اختيارية). */
data class DeviceTokenBody(
    val fcm_token: String,
    val notifications_enabled: Boolean? = null,
    val frequency_hours: Int? = null,
    val timezone_offset: Int? = null
)

/** حفظ FCM token في الداتابيز (Edge Function save-fcm-token). */
interface FcmApiService {
    @POST("save-fcm-token")
    suspend fun saveFcmToken(@Body body: DeviceTokenBody): retrofit2.Response<Unit>
}
