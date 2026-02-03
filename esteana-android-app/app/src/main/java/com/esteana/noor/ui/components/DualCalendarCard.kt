package com.esteana.noor.ui.components

import com.esteana.noor.data.HijriDateResponse
import com.esteana.noor.util.shareText
import android.os.Build
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Share
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.esteana.noor.ui.theme.EsteanaTeal
import com.esteana.noor.ui.theme.EsteanaTealLight
import java.util.Calendar
import java.util.Locale

private val HIJRI_MONTHS_AR = arrayOf(
    "محرم", "صفر", "ربيع الأول", "ربيع الآخر", "جمادى الأولى", "جمادى الآخرة",
    "رجب", "شعبان", "رمضان", "شوال", "ذو القعدة", "ذو الحجة"
)

private val GREGORIAN_MONTHS_AR = arrayOf(
    "يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو",
    "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"
)

private val WEEKDAYS_AR = arrayOf(
    "الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"
)

/**
 * يعيد التاريخ الهجري كنص (API 26+) أو null. يُستدعى عبر انعكاس لتفادي تحميل HijrahDate على API 24.
 */
private fun getHijriDateString(): String? {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return null
    return try {
        val hijrahClass = Class.forName("java.time.chrono.HijrahDate")
        val nowMethod = hijrahClass.getMethod("now")
        val hijri = nowMethod.invoke(null)!!
        val day = hijrahClass.getMethod("getDayOfMonth").invoke(hijri) as Int
        val month = hijrahClass.getMethod("getMonthValue").invoke(hijri) as Int
        val temporalFieldClass = Class.forName("java.time.temporal.TemporalField")
        val yearField = Class.forName("java.time.temporal.ChronoField").getField("YEAR").get(null)
        val year = (hijri.javaClass.getMethod("getLong", temporalFieldClass).invoke(hijri, yearField) as Long).toInt()
        "$day ${HIJRI_MONTHS_AR.getOrNull(month - 1) ?: month} $year"
    } catch (_: Throwable) {
        null
    }
}

/**
 * يعيد التاريخ الميلادي بالعربية (اليوم، اليوم في الشهر، الشهر، السنة).
 */
private fun getGregorianDateString(): String {
    val cal = Calendar.getInstance(Locale.forLanguageTag("ar-SA"))
    val weekday = WEEKDAYS_AR.getOrNull(cal.get(Calendar.DAY_OF_WEEK) - 1) ?: ""
    val day = cal.get(Calendar.DAY_OF_MONTH)
    val month = GREGORIAN_MONTHS_AR.getOrNull(cal.get(Calendar.MONTH)) ?: ""
    val year = cal.get(Calendar.YEAR)
    return "$weekday، $day $month $year"
}

/**
 * ينسق التاريخ الهجري من رد الـ API لعرضه في التقويم.
 */
private fun formatHijriFromApi(hijri: HijriDateResponse?): String? {
    if (hijri == null) return null
    val day = hijri.day?.takeIf { it.isNotBlank() }
    val monthAr = hijri.month?.ar?.takeIf { it.isNotBlank() }
    val year = hijri.year?.takeIf { it.isNotBlank() }
    if (day == null && monthAr == null && year == null) return null
    val weekdayAr = hijri.weekday?.ar?.takeIf { it.isNotBlank() }
    return when {
        weekdayAr != null && day != null && monthAr != null && year != null ->
            "$weekdayAr، $day $monthAr $year"
        day != null && monthAr != null && year != null -> "$day $monthAr $year"
        !hijri.date.isNullOrBlank() -> hijri.date
        else -> null
    }
}

/**
 * بطاقة التقويم المزدوج (هجري + ميلادي) للصفحة الرئيسية.
 * @param hijriDateFromApi التاريخ الهجري من get-noor-data (يُعرض عند توفره بدلاً من الحساب المحلي).
 */
@Composable
fun DualCalendarCard(
    modifier: Modifier = Modifier,
    hijriDateFromApi: HijriDateResponse? = null
) {
    val gregorian = getGregorianDateString()
    val hijri = formatHijriFromApi(hijriDateFromApi) ?: getHijriDateString()
    val context = LocalContext.current
    val shareTextContent = "التقويم — إستعانة\nميلادي: $gregorian\nهجري: ${hijri ?: "—"}"

    Card(
        modifier = modifier.fillMaxWidth(),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f)
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(
                    Brush.verticalGradient(
                        colors = listOf(
                            EsteanaTeal.copy(alpha = 0.15f),
                            EsteanaTealLight.copy(alpha = 0.08f)
                        )
                    )
                )
                .clip(RoundedCornerShape(20.dp))
                .padding(20.dp)
        ) {
            Column(
                modifier = Modifier.fillMaxWidth(),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "التقويم",
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.primary,
                        fontWeight = FontWeight.SemiBold
                    )
                    IconButton(
                        onClick = { shareText(context, shareTextContent) },
                        modifier = Modifier.size(40.dp)
                    ) {
                        Icon(Icons.Filled.Share, contentDescription = "مشاركة التقويم", tint = MaterialTheme.colorScheme.primary)
                    }
                }
                Spacer(modifier = Modifier.padding(vertical = 12.dp))
                Text(
                    text = gregorian,
                    style = MaterialTheme.typography.bodyLarge,
                    color = MaterialTheme.colorScheme.onSurface,
                    textAlign = TextAlign.Center
                )
                Text(
                    text = "ميلادي",
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Spacer(modifier = Modifier.padding(vertical = 8.dp))
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 4.dp)
                        .height(1.dp)
                        .background(MaterialTheme.colorScheme.outline.copy(alpha = 0.5f))
                )
                Spacer(modifier = Modifier.padding(vertical = 8.dp))
                Text(
                    text = hijri ?: "—",
                    style = MaterialTheme.typography.bodyLarge,
                    color = MaterialTheme.colorScheme.onSurface,
                    textAlign = TextAlign.Center
                )
                Text(
                    text = "هجري",
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}
