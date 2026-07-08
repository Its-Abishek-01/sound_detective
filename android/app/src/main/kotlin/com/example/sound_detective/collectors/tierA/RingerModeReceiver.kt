package com.example.sound_detective.collectors.tierA

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager
import com.example.sound_detective.core.EventBus
import com.example.sound_detective.model.SoundEvent
import com.example.sound_detective.model.SoundEventCategory
import com.example.sound_detective.model.SoundEventTier

/** Ringer mode transitions (normal/vibrate/silent). Context-only for
 * scoring — a mode change isn't a sound source, but knowing the phone
 * was muted at analysis time lets the result say "this was probably a
 * vibration" instead of blaming a notification that couldn't ring. */
class RingerModeReceiver : BroadcastReceiver() {
    companion object {
        fun filter() = IntentFilter(AudioManager.RINGER_MODE_CHANGED_ACTION)

        fun modeName(mode: Int): String = when (mode) {
            AudioManager.RINGER_MODE_NORMAL -> "NORMAL"
            AudioManager.RINGER_MODE_VIBRATE -> "VIBRATE"
            AudioManager.RINGER_MODE_SILENT -> "SILENT"
            else -> "UNKNOWN"
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val mode = intent.getIntExtra(AudioManager.EXTRA_RINGER_MODE, -1)
        if (mode == -1) return
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.RINGER,
                tier = SoundEventTier.A,
                subtype = modeName(mode),
                sourceLabel = "Ringer mode",
            ),
        )
    }
}
