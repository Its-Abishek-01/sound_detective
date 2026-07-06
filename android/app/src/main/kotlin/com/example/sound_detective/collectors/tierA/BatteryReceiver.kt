package com.example.sound_detective.collectors.tierA

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import com.example.sound_detective.core.EventBus
import com.example.sound_detective.model.SoundEvent
import com.example.sound_detective.model.SoundEventCategory
import com.example.sound_detective.model.SoundEventTier

/** Charger connect/disconnect. Uses the non-sticky, low-noise
 * POWER_CONNECTED/DISCONNECTED actions rather than BATTERY_CHANGED,
 * which fires continuously as the charge level ticks. */
class BatteryReceiver : BroadcastReceiver() {
    companion object {
        fun filter() = IntentFilter().apply {
            addAction(Intent.ACTION_POWER_CONNECTED)
            addAction(Intent.ACTION_POWER_DISCONNECTED)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val subtype = when (intent.action) {
            Intent.ACTION_POWER_CONNECTED -> "CONNECTED"
            Intent.ACTION_POWER_DISCONNECTED -> "DISCONNECTED"
            else -> return
        }
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.BATTERY,
                tier = SoundEventTier.A,
                subtype = subtype,
                sourceLabel = "Charger",
            ),
        )
    }
}
