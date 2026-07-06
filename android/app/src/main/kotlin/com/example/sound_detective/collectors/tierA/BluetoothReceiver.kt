package com.example.sound_detective.collectors.tierA

import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.core.content.IntentCompat
import com.example.sound_detective.core.EventBus
import com.example.sound_detective.model.SoundEvent
import com.example.sound_detective.model.SoundEventCategory
import com.example.sound_detective.model.SoundEventTier

class BluetoothReceiver : BroadcastReceiver() {
    companion object {
        fun filter() = IntentFilter().apply {
            addAction(BluetoothDevice.ACTION_ACL_CONNECTED)
            addAction(BluetoothDevice.ACTION_ACL_DISCONNECTED)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val subtype = when (intent.action) {
            BluetoothDevice.ACTION_ACL_CONNECTED -> "CONNECTED"
            BluetoothDevice.ACTION_ACL_DISCONNECTED -> "DISCONNECTED"
            else -> return
        }
        val device = IntentCompat.getParcelableExtra(
            intent,
            BluetoothDevice.EXTRA_DEVICE,
            BluetoothDevice::class.java,
        )
        // Reading device.name requires BLUETOOTH_CONNECT on API 31+; the
        // permission may not be granted yet (it's optional in onboarding).
        val name = try {
            device?.name
        } catch (e: SecurityException) {
            null
        } ?: "Bluetooth device"

        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.BLUETOOTH,
                tier = SoundEventTier.A,
                subtype = subtype,
                sourceLabel = name,
            ),
        )
    }
}
