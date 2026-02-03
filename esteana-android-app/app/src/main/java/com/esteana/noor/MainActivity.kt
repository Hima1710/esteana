package com.esteana.noor

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import com.esteana.noor.data.NoorDataResponse
import com.esteana.noor.data.OsnGeocoding
import com.esteana.noor.di.LocalSettingsRepository
import com.esteana.noor.ui.components.CurrentLocationRow
import com.esteana.noor.ui.components.DualCalendarCard
import com.esteana.noor.ui.components.NoorContentCard
import com.esteana.noor.ui.components.PrayerTimingsCard
import androidx.lifecycle.lifecycleScope
import com.esteana.noor.di.createSettingsRepository
import com.esteana.noor.di.saveFcmTokenToBackend
import com.esteana.noor.BuildConfig
import com.esteana.noor.ui.theme.EsteanaTheme
import com.google.firebase.messaging.FirebaseMessaging
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : ComponentActivity() {

    companion object {
        private const val TAG = "Esteana_FCM"
    }

    private val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted ->
        if (isGranted) logFcmToken()
        else {
            Log.w(TAG, "صلاحية الإشعارات مرفوضة")
            logFcmToken()
        }
    }

    private val requestLocationLauncher = registerForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions()
    ) { _ -> }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            val repository = remember { createSettingsRepository(applicationContext) }
            EsteanaTheme {
                com.esteana.noor.ui.components.EsteanaApp(
                    settingsRepository = repository,
                    onGetTokenClick = { requestNotificationPermissionAndGetToken() },
                    onSyncNotificationPrefs = { enabled, frequencyHours ->
                        FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
                            if (task.isSuccessful && task.result != null) {
                                com.esteana.noor.di.saveDeviceNotificationPrefs(
                                    applicationContext,
                                    task.result!!,
                                    enabled,
                                    frequencyHours
                                )
                            }
                        }
                    }
                )
            }
        }
        lifecycleScope.launchWhenResumed {
            requestNotificationPermissionIfNeeded()
            requestLocationPermissionIfNeeded()
        }
    }

    private fun requestLocationPermissionIfNeeded() {
        val fine = ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
        val coarse = ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED
        if (fine || coarse) return
        requestLocationLauncher.launch(
            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION)
        )
    }

    private fun requestNotificationPermissionIfNeeded() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED) return
        requestPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
    }

    private fun requestNotificationPermissionAndGetToken() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            when (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS)) {
                PackageManager.PERMISSION_GRANTED -> logFcmToken()
                else -> requestPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
            }
        } else logFcmToken()
    }

    private fun logFcmToken() {
        FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
            if (!task.isSuccessful) {
                Log.w(TAG, "فشل جلب FCM Token", task.exception)
                return@addOnCompleteListener
            }
            val token = task.result
            if (BuildConfig.DEBUG) Log.d(TAG, "FCM Token: $token")
            saveFcmTokenToBackend(applicationContext, token)
        }
    }
}

@Composable
fun MainScreen(
    modifier: Modifier = Modifier,
    onGetTokenClick: () -> Unit = {}
) {
    val repository = LocalSettingsRepository.current
    val scope = rememberCoroutineScope()
    var noorData by remember { mutableStateOf<NoorDataResponse?>(null) }
    var loading by remember { mutableStateOf(true) }
    var errorMessage by remember { mutableStateOf<String?>(null) }
    var currentLocation by remember { mutableStateOf(Pair(30.04, 31.23)) }
    var placeName by remember { mutableStateOf<String?>(null) }
    var locationRefreshing by remember { mutableStateOf(false) }

    fun refreshLocationAndData() {
        scope.launch {
            locationRefreshing = true
            currentLocation = repository.requestFreshLocation()
            placeName = withContext(Dispatchers.IO) { OsnGeocoding.getPlaceName(currentLocation.first, currentLocation.second) }
            loading = true
            errorMessage = null
            repository.fetchNoorData()
                .onSuccess { noorData = it }
                .onFailure { errorMessage = it.message ?: "حدث خطأ" }
            loading = false
            locationRefreshing = false
        }
    }

    LaunchedEffect(Unit) {
        currentLocation = repository.getCurrentLatLon()
        placeName = OsnGeocoding.getPlaceName(currentLocation.first, currentLocation.second)
        loading = true
        errorMessage = null
        repository.fetchNoorData()
            .onSuccess { noorData = it }
            .onFailure { errorMessage = it.message ?: "حدث خطأ" }
        loading = false
    }

    val scrollState = rememberScrollState()
    Column(
        modifier = modifier
            .fillMaxSize()
            .verticalScroll(scrollState)
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        DualCalendarCard(
            modifier = Modifier.fillMaxWidth(),
            hijriDateFromApi = noorData?.hijri_date
        )
        CurrentLocationRow(
            lat = currentLocation.first,
            lon = currentLocation.second,
            placeName = placeName,
            onRefresh = { refreshLocationAndData() },
            refreshing = locationRefreshing,
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(modifier = Modifier.height(20.dp))

        if (loading) {
            CircularProgressIndicator(modifier = Modifier.padding(24.dp))
        } else {
            errorMessage?.let { msg ->
                Text(
                    text = msg,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.error,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.fillMaxWidth()
                )
            }
            noorData?.let { data ->
                NoorContentCard(content = data.content, modifier = Modifier.fillMaxWidth())
                Spacer(modifier = Modifier.height(16.dp))
                PrayerTimingsCard(timings = data.timings, modifier = Modifier.fillMaxWidth())
            }
        }

        Spacer(modifier = Modifier.height(24.dp))
        Text(
            text = "مرحباً بك في تطبيق إستعانة\nرفيقك للتمسك بالسنة والكتاب طيلة الوقت",
            style = MaterialTheme.typography.headlineSmall,
            textAlign = TextAlign.Center,
            modifier = Modifier.fillMaxWidth()
        )
        if (BuildConfig.DEBUG) {
            Spacer(modifier = Modifier.height(32.dp))
            Button(onClick = onGetTokenClick, modifier = Modifier.fillMaxWidth()) {
                Text("جلب FCM Token وطباعته في Log")
            }
        }
    }
}
