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

class HeadphoneReceiver : BroadcastReceiver() {
    companion object {
        fun filter() = IntentFilter(AudioManager.ACTION_HEADSET_PLUG)
    }

    override fun onReceive(context: Context, intent: Intent) {
        val state = intent.getIntExtra("state", -1)
        if (state == -1) return
        val subtype = if (state == 1) "CONNECTED" else "DISCONNECTED"
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.HEADPHONES,
                tier = SoundEventTier.A,
                subtype = subtype,
                sourceLabel = "Headphones",
            ),
        )
    }
}
