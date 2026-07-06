package com.example.sound_detective.collectors.tierA

import android.app.AlarmManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import com.example.sound_detective.core.EventBus
import com.example.sound_detective.model.SoundEvent
import com.example.sound_detective.model.SoundEventCategory
import com.example.sound_detective.model.SoundEventTier

/** Best-effort only: Android has no public broadcast for "an alarm
 * fired in another app." ACTION_NEXT_ALARM_CLOCK_CHANGED only tells us
 * when some app's *next scheduled* alarm-clock changes, which is a much
 * weaker signal — kept with a low base weight in ScoringConfig. */
class AlarmClockReceiver : BroadcastReceiver() {
    companion object {
        fun filter() = IntentFilter(AlarmManager.ACTION_NEXT_ALARM_CLOCK_CHANGED)
    }

    override fun onReceive(context: Context, intent: Intent) {
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val next = am.nextAlarmClock
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.ALARM_CLOCK,
                tier = SoundEventTier.A,
                subtype = "NEXT_ALARM_CHANGED",
                sourceLabel = "Alarm",
                metadata = mapOf("triggerTimeMs" to next?.triggerTime),
            ),
        )
    }
}
