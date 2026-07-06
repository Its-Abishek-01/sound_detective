package com.example.sound_detective.collectors.tierA

import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import com.example.sound_detective.core.EventBus
import com.example.sound_detective.model.SoundEvent
import com.example.sound_detective.model.SoundEventCategory
import com.example.sound_detective.model.SoundEventTier

/** Wi-Fi / mobile network transitions via `registerDefaultNetworkCallback`
 * rather than the deprecated, largely-inert `CONNECTIVITY_ACTION`
 * broadcast on modern Android. */
object NetworkCollector {
    fun register(context: Context): ConnectivityManager.NetworkCallback {
        val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val callback = object : ConnectivityManager.NetworkCallback() {
            override fun onAvailable(network: Network) {
                val capabilities = cm.getNetworkCapabilities(network)
                val isWifi = capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) == true
                val category = if (isWifi) SoundEventCategory.WIFI else SoundEventCategory.MOBILE_NETWORK
                EventBus.publish(
                    SoundEvent(
                        category = category,
                        tier = SoundEventTier.A,
                        subtype = "CONNECTED",
                        sourceLabel = if (isWifi) "Wi-Fi" else "Mobile network",
                    ),
                )
            }

            override fun onLost(network: Network) {
                EventBus.publish(
                    SoundEvent(
                        category = SoundEventCategory.WIFI,
                        tier = SoundEventTier.A,
                        subtype = "DISCONNECTED",
                        sourceLabel = "Network",
                    ),
                )
            }
        }
        cm.registerDefaultNetworkCallback(callback)
        return callback
    }

    fun unregister(context: Context, callback: ConnectivityManager.NetworkCallback) {
        val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        try {
            cm.unregisterNetworkCallback(callback)
        } catch (e: IllegalArgumentException) {
            // Already unregistered.
        }
    }
}
