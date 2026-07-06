package com.example.sound_detective.collectors.tierA

import android.content.Context
import android.database.ContentObserver
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import com.example.sound_detective.core.EventBus
import com.example.sound_detective.model.SoundEvent
import com.example.sound_detective.model.SoundEventCategory
import com.example.sound_detective.model.SoundEventTier

/** Tracks the auto-rotate *setting* toggling, not live device
 * orientation via sensors — a ContentObserver on the settings row is
 * far cheaper than an OrientationEventListener and matches what the
 * product actually needs (a sound-adjacent system event, not
 * continuous orientation tracking). */
object RotationCollector {
    fun register(context: Context): ContentObserver {
        val observer = object : ContentObserver(Handler(Looper.getMainLooper())) {
            override fun onChange(selfChange: Boolean) {
                val enabled = Settings.System.getInt(
                    context.contentResolver,
                    Settings.System.ACCELEROMETER_ROTATION,
                    0,
                ) == 1
                EventBus.publish(
                    SoundEvent(
                        category = SoundEventCategory.ROTATION,
                        tier = SoundEventTier.A,
                        subtype = if (enabled) "AUTO_ROTATE_ON" else "AUTO_ROTATE_OFF",
                        sourceLabel = "Auto-rotate",
                    ),
                )
            }
        }
        context.contentResolver.registerContentObserver(
            Settings.System.getUriFor(Settings.System.ACCELEROMETER_ROTATION),
            false,
            observer,
        )
        return observer
    }

    fun unregister(context: Context, observer: ContentObserver) {
        context.contentResolver.unregisterContentObserver(observer)
    }
}
