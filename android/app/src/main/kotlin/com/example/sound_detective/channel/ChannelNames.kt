package com.example.sound_detective.channel

/** Mirrors lib/core/constants/channel_names.dart — keep in sync. */
object ChannelNames {
    const val CONTROL = "sounddetective/control"
    const val EVENTS = "sounddetective/events"
    const val SERVICE_STATUS = "sounddetective/service_status"
}

object ControlMethod {
    const val START_FOREGROUND_SERVICE = "startForegroundService"
    const val STOP_FOREGROUND_SERVICE = "stopForegroundService"
    const val IS_SERVICE_RUNNING = "isServiceRunning"

    const val CHECK_NOTIFICATION_ACCESS_GRANTED = "checkNotificationAccessGranted"
    const val OPEN_NOTIFICATION_ACCESS_SETTINGS = "openNotificationAccessSettings"

    const val CHECK_USAGE_ACCESS_GRANTED = "checkUsageAccessGranted"
    const val OPEN_USAGE_ACCESS_SETTINGS = "openUsageAccessSettings"

    const val CHECK_BLUETOOTH_PERMISSION_GRANTED = "checkBluetoothPermissionGranted"
    const val REQUEST_BLUETOOTH_PERMISSION = "requestBluetoothPermission"

    const val CHECK_BATTERY_OPTIMIZATION_EXEMPT = "checkBatteryOptimizationExempt"
    const val REQUEST_BATTERY_OPTIMIZATION_EXEMPTION = "requestBatteryOptimizationExemption"

    const val GET_RECENT_EVENTS = "getRecentEvents"
    const val RECONSTRUCT_FOREGROUND_APP = "reconstructForegroundApp"
    const val CONSUME_LAUNCH_ACTION = "consumeLaunchAction"
    const val GET_CURRENT_RINGER_MODE = "getCurrentRingerMode"
}
