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
 * only source of app-attributed audio signals.
 *
 * Bug discovered in production: dedup was originally keyed on
 * `AudioPlaybackConfiguration.hashCode()`, which is NOT stable for an
 * ongoing playback — it changes as the underlying player's internal
 * state mutates (ducking/attenuation, mute toggles from other audio
 * focus grants), even with no new playback actually starting. That
 * made a long-running stream periodically look "brand new right now"
 * to the scorer, which could win purely on freshness despite nothing
 * having just happened (e.g. reporting "Alarm sound" from a stale
 * background stream with no alarm actually ringing). Deduping on
 * *usage-type presence* instead — did this usage type go from absent
 * to present — is coarser (misses a second concurrent same-usage
 * stream) but doesn't re-fire on state mutation of an already-known
 * stream. */
object AudioFocusAndPlaybackCollector {
    private var attached = false
    private var callback: AudioManager.AudioPlaybackCallback? = null
    private val activeUsages = mutableSetOf<Int>()

    fun attach(context: Context) {
        if (attached) return
        attached = true

        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val handler = Handler(Looper.getMainLooper())
        val cb = object : AudioManager.AudioPlaybackCallback() {
            override fun onPlaybackConfigChanged(configs: MutableList<AudioPlaybackConfiguration>?) {
                val currentUsages = configs.orEmpty()
                    .mapNotNull { it.audioAttributes?.usage }
                    .toSet()
                for (usage in currentUsages) {
                    if (usage in activeUsages) continue
                    publish(usage)
                }
                activeUsages.clear()
                activeUsages.addAll(currentUsages)
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
        activeUsages.clear()
    }

    private fun publish(usage: Int) {
        val streamLabel = streamLabelFor(usage)
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.AUDIO_PLAYBACK_STATE,
                tier = SoundEventTier.B,
                subtype = "PLAYING",
                sourceLabel = streamLabel,
                metadata = mapOf("streamType" to streamLabel, "attributed" to false),
            ),
        )
    }

    /** Deliberately hedged wording — this signal can never name an app
     * (see class doc), so the label must not imply certainty about
     * *which* app, only what kind of audio was detected. */
    private fun streamLabelFor(usage: Int?): String = when (usage) {
        AudioAttributes.USAGE_MEDIA -> "Media-type audio"
        AudioAttributes.USAGE_NOTIFICATION -> "Notification-type audio"
        AudioAttributes.USAGE_ALARM -> "Alarm-type audio"
        AudioAttributes.USAGE_NOTIFICATION_RINGTONE -> "Ringtone-type audio"
        AudioAttributes.USAGE_VOICE_COMMUNICATION -> "Voice call audio"
        else -> "Unattributed audio"
    }
}
