package com.example.sound_detective.collectors.tierA

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import com.example.sound_detective.core.EventBus
import com.example.sound_detective.model.SoundEvent
import com.example.sound_detective.model.SoundEventCategory
import com.example.sound_detective.model.SoundEventTier

/** Context-only signal (see ScoringConfig.contextOnlyCategories on the
 * Dart side) — never a candidate cause on its own, just decorates the
 * result's device-state metadata. */
class ScreenReceiver : BroadcastReceiver() {
    companion object {
        fun filter() = IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_ON)
            addAction(Intent.ACTION_SCREEN_OFF)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val subtype = when (intent.action) {
            Intent.ACTION_SCREEN_ON -> "ON"
            Intent.ACTION_SCREEN_OFF -> "OFF"
            else -> return
        }
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.SCREEN,
                tier = SoundEventTier.A,
                subtype = subtype,
                sourceLabel = "Screen",
            ),
        )
    }
}
