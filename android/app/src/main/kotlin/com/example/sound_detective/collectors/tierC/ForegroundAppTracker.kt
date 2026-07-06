package com.example.sound_detective.collectors.tierC

import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import com.example.sound_detective.core.EventBus
import com.example.sound_detective.model.SoundEvent
import com.example.sound_detective.model.SoundEventCategory
import com.example.sound_detective.model.SoundEventTier
import com.example.sound_detective.util.PackageLabelResolver

/** On-demand only, never polled: reconstructs which app was actually in
 * the foreground during the lookback window by replaying UsageEvents,
 * triggered once per Detective Mode press. Avoids the battery cost of
 * continuous polling while being more accurate than a single
 * "current foreground app" snapshot taken after the fact. */
object ForegroundAppTracker {
    fun reconstruct(context: Context, windowStartMs: Long, windowEndMs: Long) {
        val usm = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val events = usm.queryEvents(windowStartMs, windowEndMs)
        val event = UsageEvents.Event()

        var lastForegroundPackage: String? = null
        var lastForegroundTime: Long = windowStartMs

        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                lastForegroundPackage = event.packageName
                lastForegroundTime = event.timeStamp
            }
        }

        val packageName = lastForegroundPackage ?: return
        val label = PackageLabelResolver.labelFor(context, packageName)
        EventBus.publish(
            SoundEvent(
                timestampMs = lastForegroundTime,
                category = SoundEventCategory.FOREGROUND_APP,
                tier = SoundEventTier.C,
                subtype = "FOREGROUND",
                sourceLabel = label,
                packageName = packageName,
                appName = label,
            ),
        )
    }
}
