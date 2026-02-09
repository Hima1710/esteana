package com.esteana.noor.data

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL

/**
 * جلب اسم المكان من إحداثيات (عكس الجيوكودينغ) عبر Nominatim (OpenStreetMap).
 * سياسة الاستخدام: https://operations.osmfoundation.org/policies/nominatim/
 */
object OsnGeocoding {

    private const val NOMINATIM_REVERSE = "https://nominatim.openstreetmap.org/reverse"
    private const val USER_AGENT = "EsteanaNoor/1.0"

    /**
     * يُرجع اسم المكان (display_name) للإحداثيات، أو null عند الفشل.
     * يُفضّل استدعاؤه من خلفية (مثلاً Dispatchers.IO).
     */
    suspend fun getPlaceName(lat: Double, lon: Double): String? = withContext(Dispatchers.IO) {
        try {
            val url = URL("$NOMINATIM_REVERSE?lat=$lat&lon=$lon&format=json&accept-language=ar")
            (url.openConnection() as HttpURLConnection).apply {
                requestMethod = "GET"
                setRequestProperty("User-Agent", USER_AGENT)
                connectTimeout = 5000
                readTimeout = 5000
            }.run {
                if (responseCode != 200) return@withContext null
                inputStream.bufferedReader().use { reader ->
                    val json = reader.readText()
                    val obj = JSONObject(json)
                    obj.optString("display_name").takeIf { it.isNotBlank() }
                }
            }
        } catch (_: Exception) {
            null
        }
    }
}
