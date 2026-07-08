package com.example.sound_detective.service

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.example.sound_detective.permissions.PermissionChecker

/** Restarts collection after a reboot — otherwise the app silently
 * stops listening until the user happens to open it again. Starting a
 * foreground service from a BOOT_COMPLETED receiver is an explicit
 * exemption from background-start restrictions. */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED &&
            intent.action != Intent.ACTION_MY_PACKAGE_REPLACED
        ) {
            return
        }
        // Always re-arm the watchdog; only start the service if the app
        // was actually set up (notification access granted).
        ServiceWatchdog.schedule(context)
        if (!PermissionChecker.isNotificationAccessGranted(context)) return
        try {
            DetectiveForegroundService.start(context)
        } catch (e: Exception) {
            Log.w("BootReceiver", "Could not start service on boot: $e")
        }
    }
}
