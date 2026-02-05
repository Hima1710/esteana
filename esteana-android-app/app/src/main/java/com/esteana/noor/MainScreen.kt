package com.esteana.noor

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier

/**
 * الشاشة الرئيسية عند استخدام EsteanaApp مع NavHost.
 * التطبيق الحالي يعتمد على WebView في MainActivity؛ هذا المكوّن للتوافق مع EsteanaComponents.
 */
@Composable
fun MainScreen(modifier: Modifier = Modifier) {
    Box(
        modifier = modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        Text("الرئيسية")
    }
}
