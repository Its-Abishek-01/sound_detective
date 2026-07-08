package com.example.sound_detective.service

import android.app.Notification
import android.app.NotificationManager
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import com.example.sound_detective.collectors.tierB.AudioFocusAndPlaybackCollector
import com.example.sound_detective.collectors.tierB.MediaSessionCollector
import com.example.sound_detective.core.EventBus
import com.example.sound_detective.core.ServiceStatusBus
import com.example.sound_detective.model.SoundEvent
import com.example.sound_detective.model.SoundEventCategory
import com.example.sound_detective.model.SoundEventTier
import com.example.sound_detective.util.PackageLabelResolver

/** Tier B entry point. Notification access is what unlocks both
 * notification-posted events AND `MediaSessionManager.getActiveSessions`
 * (the latter requires an enabled listener component), so this service
 * also boots the media/audio collectors once connected. It also
 * (re)starts [DetectiveForegroundService], since on some OEMs the
 * listener can be kept alive by the system independently of it. */
class DetectiveNotificationListenerService : NotificationListenerService() {

    override fun onListenerConnected() {
        super.onListenerConnected()
        ServiceStatusBus.publish("LISTENER_CONNECTED")
        DetectiveForegroundService.start(applicationContext)
        MediaSessionCollector.attach(this)
        AudioFocusAndPlaybackCollector.attach(applicationContext)
    }

    override fun onListenerDisconnected() {
        super.onListenerDisconnected()
        ServiceStatusBus.publish("LISTENER_DISCONNECTED")
        MediaSessionCollector.detach()
        AudioFocusAndPlaybackCollector.detach(applicationContext)
    }

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val pkg = sbn.packageName
        if (pkg == applicationContext.packageName) return
        val label = PackageLabelResolver.labelFor(applicationContext, pkg)
        val audible = isLikelyAudible(sbn)
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.NOTIFICATION_POSTED,
                tier = SoundEventTier.B,
                subtype = if (audible) "POSTED" else "POSTED_SILENT",
                sourceLabel = label,
                packageName = pkg,
                appName = label,
                metadata = mapOf("audible" to audible),
            ),
        )
    }

    /** Most notifications post *silently* (low-importance channels,
     * group summaries, ongoing/foreground-service notifications,
     * alert-once updates). Blaming those for a sound the user heard
     * would be wrong most of the time, so the scorer needs to know
     * which posts could actually have made noise. Best-effort: exact
     * "did it play a sound" isn't observable, but channel importance +
     * sound URI via the listener's ranking API is a strong proxy. */
    private fun isLikelyAudible(sbn: StatusBarNotification): Boolean {
        val n = sbn.notification

        // Ongoing/foreground-service notifications and group summaries
        // don't alert.
        if (n.flags and Notification.FLAG_GROUP_SUMMARY != 0) return false
        if (n.flags and Notification.FLAG_ONGOING_EVENT != 0) return false
        if (n.flags and Notification.FLAG_FOREGROUND_SERVICE != 0) return false

        val ranking = Ranking()
        if (currentRanking?.getRanking(sbn.key, ranking) == true) {
            val channel = ranking.channel
            if (channel != null) {
                if (channel.importance < NotificationManager.IMPORTANCE_DEFAULT) return false
                // Default+ importance but the channel has no sound set
                // (vibrate-only or fully muted channel).
                if (channel.sound == null) return false
            }
        }
        return true
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {
        val pkg = sbn.packageName
        if (pkg == applicationContext.packageName) return
        val label = PackageLabelResolver.labelFor(applicationContext, pkg)
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.NOTIFICATION_REMOVED,
                tier = SoundEventTier.B,
                subtype = "REMOVED",
                sourceLabel = label,
                packageName = pkg,
                appName = label,
            ),
        )
    }
}
