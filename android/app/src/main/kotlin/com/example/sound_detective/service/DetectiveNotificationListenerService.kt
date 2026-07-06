package com.example.sound_detective.service

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
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.NOTIFICATION_POSTED,
                tier = SoundEventTier.B,
                subtype = "POSTED",
                sourceLabel = label,
                packageName = pkg,
                appName = label,
            ),
        )
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
