package com.example.sound_detective.collectors.tierA

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import com.example.sound_detective.core.EventBus
import com.example.sound_detective.model.SoundEvent
import com.example.sound_detective.model.SoundEventCategory
import com.example.sound_detective.model.SoundEventTier

/** `android.hardware.usb.action.USB_STATE` isn't part of the public
 * UsbManager API surface, but AOSP has broadcast it unconditionally on
 * every cable connect/disconnect since Android 4.0, and it's the
 * standard (if unofficial) way apps observe USB cable state. */
class UsbReceiver : BroadcastReceiver() {
    companion object {
        private const val ACTION_USB_STATE = "android.hardware.usb.action.USB_STATE"
        fun filter() = IntentFilter(ACTION_USB_STATE)
    }

    override fun onReceive(context: Context, intent: Intent) {
        val connected = intent.getBooleanExtra("connected", false)
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.USB,
                tier = SoundEventTier.A,
                subtype = if (connected) "CONNECTED" else "DISCONNECTED",
                sourceLabel = "USB",
            ),
        )
    }
}
