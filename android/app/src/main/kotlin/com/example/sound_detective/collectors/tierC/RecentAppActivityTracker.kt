package com.example.sound_detective.collectors.tierC

import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.os.Build
import com.example.sound_detective.util.PackageLabelResolver

/** Purely informational — NOT a scoring signal. When Detective Mode
 * can't produce a confident answer (e.g. the only signal was
 * unattributed audio with no app name), this gives the user real leads
 * to investigate themselves: every app that had ANY usage activity in
 * the window, not just whichever one happened to be in the foreground.
 * That includes apps that started/stopped a foreground service, which
 * is exactly the shape of "a background music/timer app made a sound
 * with no MediaSession and no notification" — a real gap no scoring
 * rule can close given Android's public API surface (see
 * AudioFocusAndPlaybackCollector's documented limitation). Never
 * published to [com.example.sound_detective.core.EventBus] or
 * persisted — this is live, ephemeral, request-scoped context for one
 * Detective Mode screen, not part of the recorded timeline. */
object RecentAppActivityTracker {
    data class AppLead(val packageName: String, val appName: String)

    fun query(context: Context, windowStartMs: Long, windowEndMs: Long): List<AppLead> {
        val usm = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val events = usm.queryEvents(windowStartMs, windowEndMs)
        val event = UsageEvents.Event()

        val relevantTypes = mutableSetOf(
            UsageEvents.Event.MOVE_TO_FOREGROUND,
            UsageEvents.Event.MOVE_TO_BACKGROUND,
        )
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            relevantTypes.add(UsageEvents.Event.FOREGROUND_SERVICE_START)
            relevantTypes.add(UsageEvents.Event.FOREGROUND_SERVICE_STOP)
        }

        // LinkedHashSet-backed ordering: most-recently-seen package
        // first, since queryEvents returns events oldest-first.
        val seenPackages = LinkedHashMap<String, Unit>()
        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            if (event.eventType !in relevantTypes) continue
            if (event.packageName == context.packageName) continue
            seenPackages.remove(event.packageName)
            seenPackages[event.packageName] = Unit
        }

        return seenPackages.keys.reversed().map { pkg ->
            AppLead(pkg, PackageLabelResolver.labelFor(context, pkg))
        }
    }
}
