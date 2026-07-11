package com.example.sound_detective.channel

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.app.ActivityCompat
import com.example.sound_detective.collectors.tierA.RingerModeReceiver
import com.example.sound_detective.collectors.tierC.ForegroundAppTracker
import com.example.sound_detective.collectors.tierC.RecentAppActivityTracker
import com.example.sound_detective.core.EventRingBuffer
import com.example.sound_detective.permissions.PermissionChecker
import com.example.sound_detective.service.DetectiveForegroundService
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** Handles every request/response call on `sounddetective/control`.
 * Owns the one Bluetooth runtime-permission round-trip that needs an
 * Activity result callback (see [onBluetoothPermissionResult], wired
 * from MainActivity.onRequestPermissionsResult). */
class ControlChannelHandler(private val activity: Activity) : MethodChannel.MethodCallHandler {

    companion object {
        const val REQUEST_CODE_RUNTIME_PERMISSIONS = 4201
    }

    private val context get() = activity.applicationContext
    private val scope = CoroutineScope(Dispatchers.IO)
    private var pendingPermissionResult: MethodChannel.Result? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            ControlMethod.START_FOREGROUND_SERVICE -> {
                DetectiveForegroundService.start(context)
                result.success(null)
            }
            ControlMethod.STOP_FOREGROUND_SERVICE -> {
                DetectiveForegroundService.stop(context)
                result.success(null)
            }
            ControlMethod.IS_SERVICE_RUNNING -> result.success(DetectiveForegroundService.isRunning)

            ControlMethod.CHECK_NOTIFICATION_ACCESS_GRANTED ->
                result.success(PermissionChecker.isNotificationAccessGranted(context))
            ControlMethod.OPEN_NOTIFICATION_ACCESS_SETTINGS -> {
                openSettings(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                result.success(null)
            }

            ControlMethod.CHECK_USAGE_ACCESS_GRANTED ->
                result.success(PermissionChecker.isUsageAccessGranted(context))
            ControlMethod.OPEN_USAGE_ACCESS_SETTINGS -> {
                openSettings(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                result.success(null)
            }

            ControlMethod.CHECK_BLUETOOTH_PERMISSION_GRANTED ->
                result.success(PermissionChecker.isBluetoothGranted(context))
            ControlMethod.REQUEST_BLUETOOTH_PERMISSION -> requestRuntimePermissions(result)

            ControlMethod.CHECK_BATTERY_OPTIMIZATION_EXEMPT ->
                result.success(PermissionChecker.isBatteryOptimizationExempt(context))
            ControlMethod.REQUEST_BATTERY_OPTIMIZATION_EXEMPTION -> {
                requestBatteryOptimizationExemption()
                result.success(null)
            }

            ControlMethod.GET_RECENT_EVENTS -> {
                val sinceMs = (call.argument<Number>("sinceMs"))?.toLong() ?: 0L
                result.success(EventRingBuffer.eventsSince(sinceMs).map { it.toChannelMap() })
            }

            ControlMethod.CONSUME_LAUNCH_ACTION ->
                result.success(com.example.sound_detective.MainActivity.consumeLaunchAction())

            ControlMethod.GET_CURRENT_RINGER_MODE -> {
                val audioManager =
                    context.getSystemService(android.content.Context.AUDIO_SERVICE)
                        as android.media.AudioManager
                result.success(RingerModeReceiver.modeName(audioManager.ringerMode))
            }

            ControlMethod.RECONSTRUCT_FOREGROUND_APP -> {
                val start = (call.argument<Number>("windowStartMs"))?.toLong() ?: 0L
                val end = (call.argument<Number>("windowEndMs"))?.toLong() ?: System.currentTimeMillis()
                scope.launch {
                    ForegroundAppTracker.reconstruct(context, start, end)
                    withContext(Dispatchers.Main) { result.success(null) }
                }
            }

            ControlMethod.GET_RECENT_APP_ACTIVITY -> {
                val start = (call.argument<Number>("windowStartMs"))?.toLong() ?: 0L
                val end = (call.argument<Number>("windowEndMs"))?.toLong() ?: System.currentTimeMillis()
                scope.launch {
                    val leads = if (PermissionChecker.isUsageAccessGranted(context)) {
                        RecentAppActivityTracker.query(context, start, end)
                    } else {
                        emptyList()
                    }
                    withContext(Dispatchers.Main) {
                        result.success(
                            leads.map {
                                mapOf("packageName" to it.packageName, "appName" to it.appName)
                            },
                        )
                    }
                }
            }

            else -> result.notImplemented()
        }
    }

    private fun openSettings(action: String) {
        activity.startActivity(Intent(action))
    }

    /** Bundles BLUETOOTH_CONNECT (API 31+) with POST_NOTIFICATIONS
     * (API 33+) into one system dialog rather than adding a separate
     * onboarding step just for the foreground service's own
     * notification visibility. */
    private fun requestRuntimePermissions(result: MethodChannel.Result) {
        val permissions = mutableListOf<String>()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            permissions.add(android.Manifest.permission.BLUETOOTH_CONNECT)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            permissions.add(android.Manifest.permission.POST_NOTIFICATIONS)
        }
        if (permissions.isEmpty()) {
            result.success(true)
            return
        }
        pendingPermissionResult = result
        ActivityCompat.requestPermissions(
            activity,
            permissions.toTypedArray(),
            REQUEST_CODE_RUNTIME_PERMISSIONS,
        )
    }

    fun onRuntimePermissionsResult(granted: Boolean) {
        pendingPermissionResult?.success(granted)
        pendingPermissionResult = null
    }

    @SuppressLint("BatteryLife")
    private fun requestBatteryOptimizationExemption() {
        val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
            data = Uri.parse("package:${context.packageName}")
        }
        activity.startActivity(intent)
    }
}
