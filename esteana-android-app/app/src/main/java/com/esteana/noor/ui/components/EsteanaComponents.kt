package com.esteana.noor.ui.components

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.Spacer
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Share
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.ui.platform.LocalContext
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.foundation.Image
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import com.esteana.noor.R
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.esteana.noor.MainScreen
import com.esteana.noor.data.SettingsRepository
import com.esteana.noor.di.LocalSettingsRepository
import com.esteana.noor.util.shareText
import com.esteana.noor.settings.SettingsScreen

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EsteanaApp(
    settingsRepository: SettingsRepository,
    onGetTokenClick: () -> Unit,
    onSyncNotificationPrefs: (enabled: Boolean, frequencyHours: Int) -> Unit = { _, _ -> }
) {
    CompositionLocalProvider(LocalSettingsRepository provides settingsRepository) {
        val navController = rememberNavController()
        Scaffold(
            topBar = {
                TopAppBar(
                    title = {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier.padding(end = 8.dp)
                        ) {
                            Image(
                                painter = painterResource(R.drawable.logo_esteana),
                                contentDescription = "شعار إستعانة",
                                modifier = Modifier.size(32.dp)
                            )
                            Spacer(modifier = Modifier.size(8.dp))
                            Text("إستعانة")
                        }
                    },
                    navigationIcon = {
                        if (navController.currentBackStackEntry?.destination?.route == "settings") {
                            androidx.compose.material3.TextButton(
                                onClick = { navController.popBackStack() }
                            ) {
                                Icon(
                                    Icons.Filled.Home,
                                    contentDescription = null,
                                    modifier = Modifier.size(20.dp),
                                    tint = MaterialTheme.colorScheme.onSurface
                                )
                                Spacer(modifier = Modifier.size(8.dp))
                                Text("الرئيسية", color = MaterialTheme.colorScheme.onSurface)
                            }
                        }
                    },
                    actions = {
                        if (navController.currentBackStackEntry?.destination?.route == "settings") {
                            // زر إضافي للرئيسية في منطقة الـ actions (للوضوح في RTL/LTR)
                            androidx.compose.material3.FilledTonalButton(
                                onClick = { navController.popBackStack() }
                            ) {
                                Icon(Icons.Filled.Home, contentDescription = null, modifier = Modifier.size(18.dp))
                                Spacer(modifier = Modifier.size(6.dp))
                                Text("الرئيسية")
                            }
                        } else {
                            val goToSettings = {
                                navController.navigate("settings") {
                                    launchSingleTop = true
                                }
                            }
                            IconButton(onClick = goToSettings) {
                                Icon(
                                    Icons.Filled.Settings,
                                    contentDescription = "الإعدادات",
                                    tint = MaterialTheme.colorScheme.onSurface
                                )
                            }
                            androidx.compose.material3.TextButton(onClick = goToSettings) {
                                Text(
                                    "الإعدادات",
                                    color = MaterialTheme.colorScheme.onSurface
                                )
                            }
                        }
                    },
                    colors = TopAppBarDefaults.topAppBarColors(
                        containerColor = MaterialTheme.colorScheme.surface,
                        titleContentColor = MaterialTheme.colorScheme.onSurface,
                        actionIconContentColor = MaterialTheme.colorScheme.onSurface
                    )
                )
            }
        ) { innerPadding ->
            NavHost(
                navController = navController,
                startDestination = "home",
                modifier = Modifier.padding(innerPadding)
            ) {
                composable("home") {
                    MainScreen(modifier = Modifier.fillMaxSize())
                }
                composable("settings") {
                    SettingsScreen(
                        modifier = Modifier.fillMaxSize(),
                        onNavigateToHome = { navController.popBackStack() },
                        onSyncNotificationPrefs = onSyncNotificationPrefs
                    )
                }
            }
        }
    }
}

/**
 * عرض الموقع الحالي (اسم المكان من OSM إن وُجد، أو الإحداثيات) مع زر مشاركة وزر تحديث الموقع (GPS + واي فاي).
 */
@Composable
fun CurrentLocationRow(
    lat: Double,
    lon: Double,
    placeName: String? = null,
    onRefresh: (() -> Unit)? = null,
    refreshing: Boolean = false,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val displayText = if (!placeName.isNullOrBlank()) "موقعك الحالي: $placeName" else "موقعك الحالي: خط العرض ${"%.4f".format(lat)}، خط الطول ${"%.4f".format(lon)}"
    val shareTextContent = "موقعي — إستعانة\n${placeName?.takeIf { it.isNotBlank() } ?: "خط العرض ${"%.4f".format(lat)}، خط الطول ${"%.4f".format(lon)}"}"

    Row(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = displayText,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            if (!placeName.isNullOrBlank()) {
                Text(
                    text = "الإحداثيات: ${"%.4f".format(lat)}، ${"%.4f".format(lon)}",
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.8f)
                )
            }
        }
        if (onRefresh != null) {
            IconButton(
                onClick = onRefresh,
                modifier = Modifier.size(40.dp),
                enabled = !refreshing
            ) {
                if (refreshing) {
                    androidx.compose.material3.CircularProgressIndicator(
                        modifier = Modifier.size(24.dp),
                        strokeWidth = 2.dp
                    )
                } else {
                    Icon(Icons.Filled.Refresh, contentDescription = "تحديث الموقع (GPS وواي فاي)", tint = MaterialTheme.colorScheme.primary)
                }
            }
        }
        IconButton(
            onClick = { shareText(context, shareTextContent) },
            modifier = Modifier.size(40.dp)
        ) {
            Icon(Icons.Filled.Share, contentDescription = "مشاركة الموقع", tint = MaterialTheme.colorScheme.primary)
        }
    }
}

/**
 * عنوان قسم في الإعدادات أو الشاشات.
 */
@Composable
fun EsteanaSectionTitle(
    text: String,
    modifier: Modifier = Modifier
) {
    Text(
        text = text,
        style = MaterialTheme.typography.titleMedium,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        modifier = modifier.padding(horizontal = 16.dp, vertical = 8.dp)
    )
}

/**
 * بطاقة محتوى باستخدام ألوان الثيم.
 */
@Composable
fun EsteanaCard(
    modifier: Modifier = Modifier,
    content: @Composable ColumnScope.() -> Unit
) {
    Card(
        modifier = modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f)
        ),
        shape = MaterialTheme.shapes.medium
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            content = content
        )
    }
}

/**
 * صف يحتوي على نص ومفتاح تفعيل/تعطيل (Switch).
 */
@Composable
fun EsteanaSwitchRow(
    title: String,
    subtitle: String? = null,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit,
    modifier: Modifier = Modifier
) {
    Surface(
        modifier = modifier.fillMaxWidth(),
        color = MaterialTheme.colorScheme.surface,
        shape = MaterialTheme.shapes.medium
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = title,
                    style = MaterialTheme.typography.bodyLarge,
                    color = MaterialTheme.colorScheme.onSurface
                )
                if (subtitle != null) {
                    Text(
                        text = subtitle,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
            Switch(
                checked = checked,
                onCheckedChange = onCheckedChange,
                colors = SwitchDefaults.colors(
                    checkedThumbColor = MaterialTheme.colorScheme.primary,
                    checkedTrackColor = MaterialTheme.colorScheme.primaryContainer,
                    uncheckedThumbColor = MaterialTheme.colorScheme.outline,
                    uncheckedTrackColor = MaterialTheme.colorScheme.surfaceVariant
                )
            )
        }
    }
}
