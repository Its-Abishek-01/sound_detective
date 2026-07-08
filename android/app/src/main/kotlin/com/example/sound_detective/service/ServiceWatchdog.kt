package com.example.sound_detective.service

import android.content.Context
import android.util.Log
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import com.example.sound_detective.permissions.PermissionChecker
import java.util.concurrent.TimeUnit

/** OEM battery managers (Xiaomi/Samsung/Oppo especially) kill
 * long-running foreground services despite START_STICKY. This
 * periodic check restarts [DetectiveForegroundService] whenever it's
 * found dead — WorkManager survives process death and reboots, so it's
 * the reliable heartbeat the service itself can't be.
 *
 * Background FGS-start restrictions (Android 12+) are satisfied here
 * because the app holds an enabled NotificationListenerService, which
 * keeps the process in the system-bound exemption list; the try/catch
 * covers devices where that doesn't hold. */
object ServiceWatchdog {
    private const val TAG = "ServiceWatchdog"
    private const val WORK_NAME = "sound_detective_service_watchdog"

    fun schedule(context: Context) {
        val request = PeriodicWorkRequestBuilder<WatchdogWorker>(
            15, TimeUnit.MINUTES, // WorkManager's minimum periodic interval.
        ).build()
        WorkManager.getInstance(context).enqueueUniquePeriodicWork(
            WORK_NAME,
            ExistingPeriodicWorkPolicy.KEEP,
            request,
        )
    }

    class WatchdogWorker(
        context: Context,
        params: WorkerParameters,
    ) : Worker(context, params) {
        override fun doWork(): Result {
            val context = applicationContext
            if (DetectiveForegroundService.isRunning) return Result.success()
            // Without notification access the app was never set up (or
            // was revoked) — nothing useful to resurrect.
            if (!PermissionChecker.isNotificationAccessGranted(context)) {
                return Result.success()
            }
            try {
                DetectiveForegroundService.start(context)
                Log.i(TAG, "Restarted DetectiveForegroundService")
            } catch (e: Exception) {
                // e.g. ForegroundServiceStartNotAllowedException — retry
                // at the next periodic tick rather than failing the job.
                Log.w(TAG, "Could not restart service: $e")
            }
            return Result.success()
        }
    }
}
