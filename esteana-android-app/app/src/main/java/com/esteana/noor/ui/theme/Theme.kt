package com.esteana.noor.ui.theme

import android.app.Activity
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat
import com.esteana.noor.ui.theme.ColorError
import com.esteana.noor.ui.theme.ColorLightBackground
import com.esteana.noor.ui.theme.ColorLightSurface
import com.esteana.noor.ui.theme.ColorLightSurfaceVariant

private val EsteanaDarkColorScheme = darkColorScheme(
    primary = EsteanaTealLight,
    onPrimary = EsteanaOnTeal,
    primaryContainer = EsteanaTeal,
    onPrimaryContainer = EsteanaOnTeal,
    secondary = EsteanaGold,
    onSecondary = EsteanaOnGold,
    secondaryContainer = EsteanaGoldDark,
    onSecondaryContainer = EsteanaGoldLight,
    tertiary = EsteanaCircuit,
    onTertiary = EsteanaOnGold,
    background = EsteanaTealDark,
    onBackground = EsteanaOnTeal,
    surface = EsteanaTealSurface,
    onSurface = EsteanaOnTeal,
    surfaceVariant = EsteanaTeal,
    onSurfaceVariant = EsteanaCircuit,
    outline = EsteanaOutline,
    error = ColorError,
    onError = EsteanaOnTeal
)

private val EsteanaLightColorScheme = lightColorScheme(
    primary = EsteanaTeal,
    onPrimary = EsteanaOnTeal,
    primaryContainer = EsteanaTealLight,
    onPrimaryContainer = EsteanaOnTeal,
    secondary = EsteanaGoldDark,
    onSecondary = EsteanaOnTeal,
    secondaryContainer = EsteanaGoldLight,
    onSecondaryContainer = EsteanaOnGold,
    tertiary = EsteanaTealLight,
    onTertiary = EsteanaOnTeal,
    background = ColorLightBackground,
    onBackground = EsteanaTealDark,
    surface = ColorLightSurface,
    onSurface = EsteanaTealDark,
    surfaceVariant = ColorLightSurfaceVariant,
    onSurfaceVariant = EsteanaTealDark,
    outline = EsteanaOutline,
    error = ColorError,
    onError = EsteanaOnTeal
)

@Composable
fun EsteanaTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val colorScheme = if (darkTheme) EsteanaDarkColorScheme else EsteanaLightColorScheme
    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window
            window.statusBarColor = colorScheme.background.toArgb()
            WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = !darkTheme
        }
    }
    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}
