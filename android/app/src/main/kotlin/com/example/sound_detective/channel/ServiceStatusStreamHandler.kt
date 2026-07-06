package com.example.sound_detective.channel

import com.example.sound_detective.core.ServiceStatusBus
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

class ServiceStatusStreamHandler : EventChannel.StreamHandler {
    private var job: Job? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        job = CoroutineScope(Dispatchers.Main).launch {
            ServiceStatusBus.status.collect { status -> events.success(status) }
        }
    }

    override fun onCancel(arguments: Any?) {
        job?.cancel()
        job = null
    }
}
