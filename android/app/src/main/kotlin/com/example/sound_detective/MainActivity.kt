package com.example.sound_detective

import android.content.pm.PackageManager
import com.example.sound_detective.channel.ChannelNames
import com.example.sound_detective.channel.ControlChannelHandler
import com.example.sound_detective.channel.EventStreamHandler
import com.example.sound_detective.channel.ServiceStatusStreamHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var controlChannelHandler: ControlChannelHandler

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        controlChannelHandler = ControlChannelHandler(this)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ChannelNames.CONTROL)
            .setMethodCallHandler(controlChannelHandler)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, ChannelNames.EVENTS)
            .setStreamHandler(EventStreamHandler())
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, ChannelNames.SERVICE_STATUS)
            .setStreamHandler(ServiceStatusStreamHandler())
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == ControlChannelHandler.REQUEST_CODE_RUNTIME_PERMISSIONS) {
            val granted = grantResults.isNotEmpty() &&
                grantResults.all { it == PackageManager.PERMISSION_GRANTED }
            controlChannelHandler.onRuntimePermissionsResult(granted)
        }
    }
}
