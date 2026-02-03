package com.esteana.noor.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Share
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
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
import com.esteana.noor.data.ContentItem
import com.esteana.noor.util.shareText
import com.esteana.noor.ui.theme.EsteanaGold
import com.esteana.noor.ui.theme.EsteanaGoldLight
import com.esteana.noor.ui.theme.EsteanaTeal
import com.esteana.noor.ui.theme.EsteanaTealLight

private fun contentTypeLabelAr(type: String?): String = when (type?.lowercase()) {
    "quran" -> "قرآن"
    "sunnah" -> "سنة"
    "hadith" -> "حديث"
    "dhikr" -> "ذكر"
    "advice" -> "حكمة"
    else -> "محتوى"
}

/**
 * بطاقة عرض المحتوى الإيماني (آية، حديث، سنة، إلخ).
 */
@Composable
fun NoorContentCard(
    content: ContentItem?,
    modifier: Modifier = Modifier
) {
    if (content == null) return
    val text = content.content?.trim()
    if (text.isNullOrBlank()) return

    val context = LocalContext.current
    val typeLabel = contentTypeLabelAr(content.content_type)
    val shareTextContent = buildString {
        append("$typeLabel — إستعانة\n\n")
        append(text)
        content.reference?.takeIf { it.isNotBlank() }?.let { append("\n\n$it") }
    }

    Card(
        modifier = modifier.fillMaxWidth(),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f)
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Surface(
            modifier = Modifier
                .fillMaxWidth()
                .background(
                    Brush.verticalGradient(
                        colors = listOf(
                            EsteanaGold.copy(alpha = 0.12f),
                            EsteanaGoldLight.copy(alpha = 0.06f)
                        )
                    )
                )
                .clip(RoundedCornerShape(20.dp))
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(20.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Surface(
                        shape = RoundedCornerShape(12.dp),
                        color = MaterialTheme.colorScheme.primaryContainer.copy(alpha = 0.7f)
                    ) {
                        Text(
                            text = typeLabel,
                            style = MaterialTheme.typography.labelMedium,
                            color = MaterialTheme.colorScheme.onPrimaryContainer,
                            modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp),
                            fontWeight = FontWeight.SemiBold
                        )
                    }
                    IconButton(
                        onClick = { shareText(context, shareTextContent) },
                        modifier = Modifier.size(40.dp)
                    ) {
                        Icon(Icons.Filled.Share, contentDescription = "مشاركة المحتوى", tint = MaterialTheme.colorScheme.primary)
                    }
                }
                Spacer(modifier = Modifier.height(14.dp))
                Text(
                    text = text,
                    style = MaterialTheme.typography.bodyLarge,
                    color = MaterialTheme.colorScheme.onSurface,
                    textAlign = TextAlign.Center,
                    lineHeight = MaterialTheme.typography.bodyLarge.lineHeight
                )
                content.reference?.takeIf { it.isNotBlank() }?.let { ref ->
                    Spacer(modifier = Modifier.height(10.dp))
                    Text(
                        text = ref,
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
    }
}

private val MORNING_PRAYERS = listOf("Fajr", "Sunrise", "Dhuhr", "Asr")
private val EVENING_PRAYERS = listOf("Sunset", "Maghrib", "Isha")

private fun prayerNameAr(key: String): String = when (key) {
    "Fajr" -> "الفجر"
    "Sunrise" -> "الشروق"
    "Dhuhr" -> "الظهر"
    "Asr" -> "العصر"
    "Sunset" -> "الغروب"
    "Maghrib" -> "المغرب"
    "Isha" -> "العشاء"
    "Imsak" -> "الإمساك"
    "Midnight" -> "منتصف الليل"
    else -> key
}

/** التطبيق يعرض كل الأوقات بنظام 12 ساعة (ص/م). تحويل من 24 ساعة إلى 12 ساعة. */
private fun formatTime12h(time24: String): String {
    val normalized = time24.trim().split(" ").firstOrNull() ?: time24
    val parts = normalized.split(":")
    if (parts.size < 2) return time24
    val hour = parts[0].toIntOrNull() ?: return time24
    val minute = parts[1].take(2)
    val (h12, amPm) = when {
        hour == 0 -> 12 to "ص"
        hour < 12 -> hour to "ص"
        hour == 12 -> 12 to "م"
        else -> (hour - 12) to "م"
    }
    return "$h12:$minute $amPm"
}

/**
 * بطاقة أوقات الصلاة في شبكة أنيقة.
 */
@Composable
fun PrayerTimingsCard(
    timings: Map<String, String>?,
    modifier: Modifier = Modifier
) {
    if (timings.isNullOrEmpty()) return

    val morningEntries = MORNING_PRAYERS.mapNotNull { key ->
        timings[key]?.let { time -> key to time }
    }
    val eveningEntries = EVENING_PRAYERS.mapNotNull { key ->
        timings[key]?.let { time -> key to time }
    }

    val context = LocalContext.current
    val shareTextContent = buildString {
        append("أوقات الصلاة — إستعانة\n\n")
        append("صباحاً\n")
        morningEntries.forEach { (key, time) -> append("${prayerNameAr(key)}: ${formatTime12h(time)}\n") }
        append("\nمساءً\n")
        eveningEntries.forEach { (key, time) -> append("${prayerNameAr(key)}: ${formatTime12h(time)}\n") }
    }

    Card(
        modifier = modifier.fillMaxWidth(),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f)
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Surface(
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
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(20.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "أوقات الصلاة",
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.primary,
                        fontWeight = FontWeight.SemiBold
                    )
                    IconButton(
                        onClick = { shareText(context, shareTextContent) },
                        modifier = Modifier.size(40.dp)
                    ) {
                        Icon(Icons.Filled.Share, contentDescription = "مشاركة أوقات الصلاة", tint = MaterialTheme.colorScheme.primary)
                    }
                }
                Spacer(modifier = Modifier.height(16.dp))

                Text(
                    text = "صباحاً",
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.primary,
                    fontWeight = FontWeight.SemiBold
                )
                Spacer(modifier = Modifier.height(8.dp))
                morningEntries.forEach { (key, time) ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 4.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = prayerNameAr(key),
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.onSurface
                        )
                        Text(
                            text = formatTime12h(time),
                            style = MaterialTheme.typography.titleMedium,
                            color = MaterialTheme.colorScheme.primary,
                            fontWeight = FontWeight.Medium
                        )
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))
                Text(
                    text = "مساءً",
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.primary,
                    fontWeight = FontWeight.SemiBold
                )
                Spacer(modifier = Modifier.height(8.dp))
                eveningEntries.forEach { (key, time) ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 4.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = prayerNameAr(key),
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.onSurface
                        )
                        Text(
                            text = formatTime12h(time),
                            style = MaterialTheme.typography.titleMedium,
                            color = MaterialTheme.colorScheme.primary,
                            fontWeight = FontWeight.Medium
                        )
                    }
                }
            }
        }
    }
}
