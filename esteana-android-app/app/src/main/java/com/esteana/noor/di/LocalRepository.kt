package com.esteana.noor.di

import androidx.compose.runtime.compositionLocalOf
import com.esteana.noor.data.SettingsRepository

val LocalSettingsRepository = compositionLocalOf<SettingsRepository> {
    error("No SettingsRepository provided")
}
