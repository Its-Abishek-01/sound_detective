package com.example.sound_detective.collectors.tierA

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import com.example.sound_detective.core.EventBus
import com.example.sound_detective.model.SoundEvent
import com.example.sound_detective.model.SoundEventCategory
import com.example.sound_detective.model.SoundEventTier

class DndReceiver : BroadcastReceiver() {
    companion object {
        fun filter() = IntentFilter(NotificationManager.ACTION_INTERRUPTION_FILTER_CHANGED)
    }

    override fun onReceive(context: Context, intent: Intent) {
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val subtype = when (nm.currentInterruptionFilter) {
            NotificationManager.INTERRUPTION_FILTER_ALL -> "OFF"
            NotificationManager.INTERRUPTION_FILTER_NONE -> "TOTAL_SILENCE"
            NotificationManager.INTERRUPTION_FILTER_PRIORITY -> "PRIORITY_ONLY"
            NotificationManager.INTERRUPTION_FILTER_ALARMS -> "ALARMS_ONLY"
            else -> "UNKNOWN"
        }
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.DND,
                tier = SoundEventTier.A,
                subtype = subtype,
                sourceLabel = "Do Not Disturb",
            ),
        )
    }
}
