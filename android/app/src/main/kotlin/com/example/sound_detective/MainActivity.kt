package com.example.sound_detective

import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import com.example.sound_detective.channel.ChannelNames
import com.example.sound_detective.channel.ControlChannelHandler
import com.example.sound_detective.channel.EventStreamHandler
import com.example.sound_detective.channel.ServiceStatusStreamHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        const val ACTION_ANALYZE_NOW = "com.example.sound_detective.ANALYZE_NOW"

        /** Set when the activity is launched with an action intent
         * (e.g. from the Quick Settings tile) and cleared when Dart
         * consumes it via the control channel — a pull model, so it
         * works for both cold starts (Dart asks after first frame) and
         * warm starts (Dart re-asks on app resume). */
        @Volatile
        var pendingLaunchAction: String? = null
            private set

        fun consumeLaunchAction(): String? {
            val action = pendingLaunchAction
            pendingLaunchAction = null
            return action
        }
    }

    private lateinit var controlChannelHandler: ControlChannelHandler

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        captureLaunchAction(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        captureLaunchAction(intent)
    }

    private fun captureLaunchAction(intent: Intent?) {
        if (intent?.action == ACTION_ANALYZE_NOW) {
            pendingLaunchAction = "analyze"
        }
    }

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
