package com.esteana.noor.data

import java.time.LocalDate
import java.time.LocalTime

/**
 * تردد التنبيهات.
 * الوضع الصامت الليلي (11 مساءً - 5 صباحاً) يُدار من جانب الـ API.
 */
enum class NotificationFrequency(val hours: Int, val labelAr: String) {
    EVERY_HOUR(1, "كل ساعة"),
    EVERY_3_HOURS(3, "كل 3 ساعات"),
    EVERY_6_HOURS(6, "كل 6 ساعات");

    companion object {
        fun fromHours(h: Int) = entries.find { it.hours == h } ?: EVERY_3_HOURS
    }
}

/**
 * الجنس للمعامل gender في الـ API.
 * مطابق لعمود target_gender في islamic_content: male | female | both
 */
enum class GenderOption(val value: String, val labelAr: String) {
    MALE("male", "ذكر"),
    FEMALE("female", "أنثى"),
    BOTH("both", "يفضل عدم التحديد");

    fun targetGender(): String = value

    companion object {
        fun fromValue(v: String) = entries.find { it.value == v } ?: BOTH
    }
}

/**
 * الوظيفة للمعامل job في الـ API.
 * القيم مطابقة لعمود target_occupation في جدول islamic_content.
 */
enum class JobOption(val value: String, val labelAr: String) {
    STUDENT("any", "طالب"),
    EMPLOYEE("worker", "موظف"),
    HOMEMAKER("any", "رب منزل"),
    TEACHER("any", "معلم"),
    PROGRAMMER("programmer", "مبرمج"),
    DESIGNER("designer", "مصمم"),
    OTHER("any", "آخر");

    /** القيمة المرسلة للـ API وللداتابيز (target_occupation). */
    fun targetOccupation(): String = value

    companion object {
        fun fromValue(v: String) = entries.find { it.value == v } ?: OTHER
    }
}

data class UserSettings(
    val birthDate: LocalDate? = null,
    val job: JobOption = JobOption.OTHER,
    val gender: GenderOption = GenderOption.BOTH,
    val notificationFrequency: NotificationFrequency = NotificationFrequency.EVERY_3_HOURS,
    val notificationsEnabled: Boolean = true
) {
    /** العمر محسوباً من تاريخ الميلاد. */
    fun calculatedAge(): Int? = birthDate?.let { birth ->
        val today = LocalDate.now()
        var age = today.year - birth.year
        if (today.monthValue < birth.monthValue || (today.monthValue == birth.monthValue && today.dayOfMonth < birth.dayOfMonth)) {
            age--
        }
        age.coerceAtLeast(0)
    }

    /**
     * تحويل العمر إلى age_group مطابق لجدول islamic_content.
     * القيم: child, adult, both, all
     */
    fun ageGroupForDb(): String {
        val age = calculatedAge() ?: return "all"
        return when {
            age <= 12 -> "child"
            age in 13..17 -> "both"
            else -> "adult"
        }
    }
}

/**
 * طلب إرسال الإعدادات إلى الـ API.
 * المعاملات: Lat, Lon, Age, Job, Gender, Time + age_group, target_occupation (مطابقة لـ islamic_content).
 */
data class SettingsApiRequest(
    val lat: Double,
    val lon: Double,
    val age: Int,
    val job: String,
    val gender: String,
    val time: String,
    val age_group: String,
    val target_occupation: String
)
