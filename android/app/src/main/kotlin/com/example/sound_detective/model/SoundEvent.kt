package com.example.sound_detective.model

import org.json.JSONObject
import java.util.UUID

/** Mirrors lib/data/models/sound_event.dart's SoundEventTier — keep in sync. */
enum class SoundEventTier(val wireName: String) {
    A("A"),
    B("B"),
    C("C"),
}

/** Mirrors lib/data/models/sound_event.dart's SoundEventCategory — keep in sync. */
enum class SoundEventCategory(val wireName: String) {
    BATTERY("BATTERY"),
    HEADPHONES("HEADPHONES"),
    BLUETOOTH("BLUETOOTH"),
    USB("USB"),
    WIFI("WIFI"),
    MOBILE_NETWORK("MOBILE_NETWORK"),
    SCREEN("SCREEN"),
    ROTATION("ROTATION"),
    VOLUME("VOLUME"),
    DND("DND"),
    RINGER("RINGER"),
    ALARM_CLOCK("ALARM_CLOCK"),
    NOTIFICATION_POSTED("NOTIFICATION_POSTED"),
    NOTIFICATION_REMOVED("NOTIFICATION_REMOVED"),
    MEDIA_SESSION("MEDIA_SESSION"),
    AUDIO_FOCUS("AUDIO_FOCUS"),
    AUDIO_PLAYBACK_STATE("AUDIO_PLAYBACK_STATE"),
    FOREGROUND_APP("FOREGROUND_APP"),
}

/**
 * The single unified event shape published by every collector. Matches
 * lib/data/models/sound_event.dart field-for-field so [toChannelMap] can
 * be decoded by `SoundEvent.fromChannelMap` on the Dart side unchanged.
 */
data class SoundEvent(
    val id: String = UUID.randomUUID().toString(),
    val timestampMs: Long = System.currentTimeMillis(),
    val category: SoundEventCategory,
    val tier: SoundEventTier,
    val subtype: String = "",
    val sourceLabel: String = "",
    val packageName: String? = null,
    val appName: String? = null,
    val metadata: Map<String, Any?> = emptyMap(),
    val confidenceWeight: Double = 0.0,
) {
    fun toChannelMap(): Map<String, Any?> = mapOf(
        "id" to id,
        "timestampMs" to timestampMs,
        "category" to category.wireName,
        "tier" to tier.wireName,
        "subtype" to subtype,
        "sourceLabel" to sourceLabel,
        "packageName" to packageName,
        "appName" to appName,
        "metadataJson" to JSONObject(metadata.filterValues { it != null }).toString(),
        "confidenceWeight" to confidenceWeight,
    )
}
