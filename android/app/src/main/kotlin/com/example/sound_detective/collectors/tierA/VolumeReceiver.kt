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

/** `android.media.VOLUME_CHANGED_ACTION` is a long-standing hidden
 * broadcast (not declared in the public AudioManager API surface) but
 * is the standard, widely-relied-upon way apps observe volume changes
 * without polling — simpler and more reliable here than a ContentObserver
 * on the settings DB. */
class VolumeReceiver : BroadcastReceiver() {
    companion object {
        private const val ACTION_VOLUME_CHANGED = "android.media.VOLUME_CHANGED_ACTION"
        private const val EXTRA_VOLUME_STREAM_TYPE = "android.media.EXTRA_VOLUME_STREAM_TYPE"
        fun filter() = IntentFilter(ACTION_VOLUME_CHANGED)
    }

    override fun onReceive(context: Context, intent: Intent) {
        val streamType = intent.getIntExtra(EXTRA_VOLUME_STREAM_TYPE, -1)
        val label = when (streamType) {
            AudioManager.STREAM_MUSIC -> "Media volume"
            AudioManager.STREAM_RING -> "Ringtone volume"
            AudioManager.STREAM_NOTIFICATION -> "Notification volume"
            AudioManager.STREAM_ALARM -> "Alarm volume"
            else -> "Volume"
        }
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.VOLUME,
                tier = SoundEventTier.A,
                subtype = "CHANGED",
                sourceLabel = label,
            ),
        )
    }
}
