package com.example.sound_detective.collectors.tierB

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.AudioPlaybackConfiguration
import android.os.Handler
import android.os.Looper
import com.example.sound_detective.core.EventBus
import com.example.sound_detective.model.SoundEvent
import com.example.sound_detective.model.SoundEventCategory
import com.example.sound_detective.model.SoundEventTier

/** There is no public broadcast for *other apps'* audio focus changes.
 * The real, observable signal is the list of active playback
 * configurations from `AudioManager.AudioPlaybackCallback` (API 26+),
 * which is what this collector actually watches — "Audio Focus
 * changed" is kept only as the user-facing phrase in ReasonTemplates.
 *
 * Important limitation discovered during implementation:
 * `AudioPlaybackConfiguration.getClientUid()` and `isActive()` are
 * `@SystemApi` — hidden from the public SDK entirely, not just
 * permission-gated. A third-party app cannot attribute a playback
 * config to a package/UID through public API. This collector therefore
 * publishes a generic, unattributed "something is playing audio"
 * candidate (system-level, no packageName) built from the
 * `AudioAttributes` usage type; [MediaSessionCollector] remains the
 * only source of app-attributed audio signals. The configs passed to
 * `onPlaybackConfigChanged` are documented as the currently *active*
 * set, so no extra activity filtering is needed or possible here. */
object AudioFocusAndPlaybackCollector {
    private var attached = false
    private var callback: AudioManager.AudioPlaybackCallback? = null
    private val knownConfigs = mutableSetOf<Int>()

    fun attach(context: Context) {
        if (attached) return
        attached = true

        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val handler = Handler(Looper.getMainLooper())
        val cb = object : AudioManager.AudioPlaybackCallback() {
            override fun onPlaybackConfigChanged(configs: MutableList<AudioPlaybackConfiguration>?) {
                val current = configs.orEmpty()
                val currentHashes = current.map { it.hashCode() }.toSet()
                for (config in current) {
                    if (config.hashCode() in knownConfigs) continue
                    publish(config)
                }
                knownConfigs.clear()
                knownConfigs.addAll(currentHashes)
            }
        }
        audioManager.registerAudioPlaybackCallback(cb, handler)
        callback = cb
    }

    fun detach(context: Context) {
        val cb = callback ?: return
        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        audioManager.unregisterAudioPlaybackCallback(cb)
        callback = null
        attached = false
        knownConfigs.clear()
    }

    private fun publish(config: AudioPlaybackConfiguration) {
        val streamLabel = streamLabelFor(config.audioAttributes?.usage)
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.AUDIO_PLAYBACK_STATE,
                tier = SoundEventTier.B,
                subtype = "PLAYING",
                sourceLabel = streamLabel,
                metadata = mapOf("streamType" to streamLabel),
            ),
        )
    }

    private fun streamLabelFor(usage: Int?): String = when (usage) {
        AudioAttributes.USAGE_MEDIA -> "Media playback"
        AudioAttributes.USAGE_NOTIFICATION -> "Notification sound"
        AudioAttributes.USAGE_ALARM -> "Alarm sound"
        AudioAttributes.USAGE_NOTIFICATION_RINGTONE -> "Ringtone"
        AudioAttributes.USAGE_VOICE_COMMUNICATION -> "Voice call audio"
        else -> "Audio playback"
    }
}
