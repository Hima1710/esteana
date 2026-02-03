package com.esteana.noor.data

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.LocationManager
import androidx.core.content.ContextCompat
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.suspendCancellableCoroutine
import java.time.LocalDate
import kotlin.coroutines.resume
import java.time.LocalTime
import java.time.format.DateTimeFormatter

private val Context.settingsDataStore: DataStore<Preferences> by preferencesDataStore(name = "user_settings")

private val KEY_BIRTH_YEAR = intPreferencesKey("birth_year")
private val KEY_BIRTH_MONTH = intPreferencesKey("birth_month")
private val KEY_BIRTH_DAY = intPreferencesKey("birth_day")
private val KEY_JOB = stringPreferencesKey("job")
private val KEY_GENDER = stringPreferencesKey("gender")
private val KEY_FREQUENCY_HOURS = intPreferencesKey("notification_frequency_hours")
private val KEY_NOTIFICATIONS_ENABLED = booleanPreferencesKey("notifications_enabled")

class SettingsRepository(
    private val context: Context,
    private val api: SettingsApiService?
) {

    val settings: Flow<UserSettings> = context.settingsDataStore.data.map { prefs ->
        val year = prefs[KEY_BIRTH_YEAR]
        val month = prefs[KEY_BIRTH_MONTH]
        val day = prefs[KEY_BIRTH_DAY]
        val birthDate = if (year != null && month != null && day != null) {
            try {
                LocalDate.of(year, month, day)
            } catch (_: Exception) {
                null
            }
        } else null

        UserSettings(
            birthDate = birthDate,
            job = JobOption.fromValue(prefs[KEY_JOB] ?: JobOption.OTHER.value),
            gender = GenderOption.fromValue(prefs[KEY_GENDER] ?: GenderOption.BOTH.value),
            notificationFrequency = NotificationFrequency.fromHours(prefs[KEY_FREQUENCY_HOURS] ?: 3),
            notificationsEnabled = prefs[KEY_NOTIFICATIONS_ENABLED] ?: true
        )
    }

    suspend fun setBirthDate(date: LocalDate?) {
        context.settingsDataStore.edit { prefs ->
            if (date != null) {
                prefs[KEY_BIRTH_YEAR] = date.year
                prefs[KEY_BIRTH_MONTH] = date.monthValue
                prefs[KEY_BIRTH_DAY] = date.dayOfMonth
            } else {
                prefs.remove(KEY_BIRTH_YEAR)
                prefs.remove(KEY_BIRTH_MONTH)
                prefs.remove(KEY_BIRTH_DAY)
            }
        }
    }

    suspend fun setJob(job: JobOption) {
        context.settingsDataStore.edit { it[KEY_JOB] = job.value }
    }

    suspend fun setGender(gender: GenderOption) {
        context.settingsDataStore.edit { it[KEY_GENDER] = gender.value }
    }

    suspend fun setNotificationFrequency(freq: NotificationFrequency) {
        context.settingsDataStore.edit { it[KEY_FREQUENCY_HOURS] = freq.hours }
    }

    suspend fun setNotificationsEnabled(enabled: Boolean) {
        context.settingsDataStore.edit { it[KEY_NOTIFICATIONS_ENABLED] = enabled }
    }

    private val cairoLat = 30.04
    private val cairoLon = 31.23

    /** سحب الموقع تلقائياً إن وُجدت الصلاحية؛ وإلا إحداثيات القاهرة. */
    private fun getLatLon(): Pair<Double, Double> {
        val hasLocation = ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED ||
            ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED
        if (!hasLocation) return cairoLat to cairoLon
        val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as? LocationManager ?: return cairoLat to cairoLon
        val location = try {
            locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
                ?: locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER)
        } catch (_: SecurityException) {
            null
        }
        return if (location != null) location.latitude to location.longitude else cairoLat to cairoLon
    }

    /**
     * طلب موقع محدّث بدقة عالية (GPS + شبكة الواي فاي والخلوي).
     * يُستدعى عند الضغط على زر التحديث لقراءة أدق.
     */
    suspend fun requestFreshLocation(): Pair<Double, Double> {
        val hasLocation = ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED ||
            ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED
        if (!hasLocation) return cairoLat to cairoLon
        val client: FusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(context)
        return suspendCancellableCoroutine { cont ->
            client.getCurrentLocation(Priority.PRIORITY_HIGH_ACCURACY, null)
                .addOnSuccessListener { location ->
                    if (location != null) cont.resume(location.latitude to location.longitude)
                    else cont.resume(cairoLat to cairoLon)
                }
                .addOnFailureListener { cont.resume(cairoLat to cairoLon) }
        }
    }

    /** إرجاع الموقع الحالي للعرض في الواجهة (نفس القيم المُرسلة للـ API). */
    fun getCurrentLatLon(): Pair<Double, Double> = getLatLon()

    /**
     * إرسال الإعدادات إلى الـ API: Lat, Lon, Age, Job, Gender, Time + age_group, target_occupation.
     */
    suspend fun syncToApi(settings: UserSettings): Result<Unit> {
        val age = settings.calculatedAge() ?: return Result.failure(IllegalStateException("يجب اختيار تاريخ الميلاد"))
        val (lat, lon) = getLatLon()
        val request = SettingsApiRequest(
            lat = lat,
            lon = lon,
            age = age,
            job = settings.job.value,
            gender = settings.gender.targetGender(),
            time = LocalTime.now().format(DateTimeFormatter.ISO_LOCAL_TIME),
            age_group = settings.ageGroupForDb(),
            target_occupation = settings.job.targetOccupation()
        )
        return try {
            val response = api?.sendSettings(request)
            if (response != null && response.isSuccessful) {
                Result.success(Unit)
            } else {
                Result.failure(Exception(response?.message() ?: "API error"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    /**
     * جلب المحتوى اليومي وأوقات الصلاة والتاريخ الهجري للعرض في الرئيسية (يستخدم الموقع تلقائياً إن وُجدت الصلاحية).
     */
    suspend fun fetchNoorData(): Result<NoorDataResponse> {
        val (lat, lon) = getLatLon()
        return try {
            val response = api?.getNoorData(lat, lon)
            if (response != null && response.isSuccessful) {
                response.body()?.let { Result.success(it) } ?: Result.failure(Exception("Empty response"))
            } else {
                Result.failure(Exception(response?.message() ?: "API error"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
