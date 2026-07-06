package com.example.sound_detective.channel

import com.example.sound_detective.core.EventBus
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

/** Streams every published [com.example.sound_detective.model.SoundEvent]
 * to Dart as `{"event": <map>}`, matching `SoundEvent.fromChannelMap`'s
 * expected envelope on the Dart side. */
class EventStreamHandler : EventChannel.StreamHandler {
    private var job: Job? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        job = CoroutineScope(Dispatchers.Main).launch {
            EventBus.events.collect { event ->
                events.success(mapOf("event" to event.toChannelMap()))
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        job?.cancel()
        job = null
    }
}
