package com.esteana.noor.util

import android.content.Context
import android.content.Intent

/** فتح نافذة مشاركة النص عبر التطبيقات (واتساب، تويتر، إلخ). */
fun shareText(context: Context, text: String) {
    val intent = Intent(Intent.ACTION_SEND).apply {
        type = "text/plain"
        putExtra(Intent.EXTRA_TEXT, text)
    }
    context.startActivity(Intent.createChooser(intent, "مشاركة"))
}
