package com.example.sound_detective.service

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ServiceInfo
import android.database.ContentObserver
import android.net.ConnectivityManager
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import androidx.core.content.ContextCompat
import com.example.sound_detective.MainActivity
import com.example.sound_detective.R
import com.example.sound_detective.collectors.tierA.AlarmClockReceiver
import com.example.sound_detective.collectors.tierA.BatteryReceiver
import com.example.sound_detective.collectors.tierA.BluetoothReceiver
import com.example.sound_detective.collectors.tierA.DndReceiver
import com.example.sound_detective.collectors.tierA.HeadphoneReceiver
import com.example.sound_detective.collectors.tierA.NetworkCollector
import com.example.sound_detective.collectors.tierA.RingerModeReceiver
import com.example.sound_detective.collectors.tierA.RotationCollector
import com.example.sound_detective.collectors.tierA.ScreenReceiver
import com.example.sound_detective.collectors.tierA.UsbReceiver
import com.example.sound_detective.collectors.tierA.VolumeReceiver
import com.example.sound_detective.core.ServiceStatusBus

/** Always-on host for every Tier A collector. Broadcasts are registered
 * dynamically here (not in the manifest) since most of them are
 * implicit-broadcast-restricted from manifest declaration on API 26+. */
class DetectiveForegroundService : Service() {

    private val dynamicReceivers = mutableListOf<BroadcastReceiver>()
    private var networkCallback: ConnectivityManager.NetworkCallback? = null
    private var rotationObserver: ContentObserver? = null

    companion object {
        private const val CHANNEL_ID = "sound_detective_service"
        private const val NOTIFICATION_ID = 1

        @Volatile
        var isRunning = false
            private set

        fun start(context: Context) {
            val intent = Intent(context, DetectiveForegroundService::class.java)
            ContextCompat.startForegroundService(context, intent)
        }

        fun stop(context: Context) {
            context.stopService(Intent(context, DetectiveForegroundService::class.java))
        }
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        ServiceCompat.startForeground(
            this,
            NOTIFICATION_ID,
            buildNotification(),
            ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE,
        )
        isRunning = true
        ServiceStatusBus.publish("STARTED")
        registerTierACollectors()
        // Idempotent (KEEP policy) — re-arms the resurrection watchdog
        // on every legitimate start so it's always scheduled.
        ServiceWatchdog.schedule(this)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int = START_STICKY

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        isRunning = false
        ServiceStatusBus.publish("STOPPED")
        unregisterTierACollectors()
    }

    private fun registerTierACollectors() {
        registerBroadcast(BatteryReceiver(), BatteryReceiver.filter())
        registerBroadcast(HeadphoneReceiver(), HeadphoneReceiver.filter())
        registerBroadcast(BluetoothReceiver(), BluetoothReceiver.filter())
        registerBroadcast(UsbReceiver(), UsbReceiver.filter())
        registerBroadcast(ScreenReceiver(), ScreenReceiver.filter())
        registerBroadcast(DndReceiver(), DndReceiver.filter())
        registerBroadcast(AlarmClockReceiver(), AlarmClockReceiver.filter())
        registerBroadcast(VolumeReceiver(), VolumeReceiver.filter())
        registerBroadcast(RingerModeReceiver(), RingerModeReceiver.filter())
        networkCallback = NetworkCollector.register(this)
        rotationObserver = RotationCollector.register(this)
    }

    private fun registerBroadcast(receiver: BroadcastReceiver, filter: IntentFilter) {
        ContextCompat.registerReceiver(this, receiver, filter, ContextCompat.RECEIVER_NOT_EXPORTED)
        dynamicReceivers.add(receiver)
    }

    private fun unregisterTierACollectors() {
        dynamicReceivers.forEach { runCatching { unregisterReceiver(it) } }
        dynamicReceivers.clear()
        networkCallback?.let { NetworkCollector.unregister(this, it) }
        networkCallback = null
        rotationObserver?.let { RotationCollector.unregister(this, it) }
        rotationObserver = null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Sound Detective listening",
            NotificationManager.IMPORTANCE_MIN,
        )
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(channel)
    }

    private fun buildNotification(): Notification {
        val openAppIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        val openAppPendingIntent = PendingIntent.getActivity(
            this,
            0,
            openAppIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Sound Detective")
            .setContentText("Listening in the background")
            .setSmallIcon(R.drawable.ic_stat_sound_detective)
            .setContentIntent(openAppPendingIntent)
            .setPriority(NotificationCompat.PRIORITY_MIN)
            .setOngoing(true)
            .build()
    }
}
