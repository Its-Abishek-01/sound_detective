package com.example.sound_detective.core

import com.example.sound_detective.model.SoundEvent
import kotlinx.coroutines.channels.BufferOverflow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.asSharedFlow

/**
 * Single pipeline every collector (Tier A/B/C) publishes into. Nothing
 * else in the app should construct its own event stream — this is the
 * one seam between "something happened" and "something is stored".
 */
object EventBus {
    private val _events = MutableSharedFlow<SoundEvent>(
        replay = 0,
        extraBufferCapacity = 64,
        onBufferOverflow = BufferOverflow.DROP_OLDEST,
    )
    val events: SharedFlow<SoundEvent> = _events.asSharedFlow()

    fun publish(event: SoundEvent) {
        EventRingBuffer.add(event)
        _events.tryEmit(event)
    }
}

/**
 * Bounded backfill buffer: if the Flutter engine detaches while the
 * foreground service keeps running, events published in the meantime
 * would otherwise be lost to Dart. `getRecentEvents` replays from here
 * once the engine reattaches and the EventChannel's onListen fires.
 */
object EventRingBuffer {
    private const val MAX_SIZE = 500
    private val buffer = ArrayDeque<SoundEvent>()

    @Synchronized
    fun add(event: SoundEvent) {
        buffer.addLast(event)
        if (buffer.size > MAX_SIZE) buffer.removeFirst()
    }

    @Synchronized
    fun eventsSince(sinceMs: Long): List<SoundEvent> =
        buffer.filter { it.timestampMs >= sinceMs }
}

/** Backing stream for the `sounddetective/service_status` EventChannel. */
object ServiceStatusBus {
    private val _status = MutableSharedFlow<String>(
        replay = 1,
        extraBufferCapacity = 8,
        onBufferOverflow = BufferOverflow.DROP_OLDEST,
    )
    val status: SharedFlow<String> = _status.asSharedFlow()

    fun publish(status: String) {
        _status.tryEmit(status)
    }
}
