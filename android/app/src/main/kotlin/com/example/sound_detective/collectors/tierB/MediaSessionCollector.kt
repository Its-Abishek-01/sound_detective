package com.example.sound_detective.collectors.tierB

import android.content.ComponentName
import android.content.Context
import android.media.MediaMetadata
import android.media.session.MediaController
import android.media.session.MediaSession
import android.media.session.MediaSessionManager
import android.media.session.PlaybackState
import android.service.notification.NotificationListenerService
import com.example.sound_detective.core.EventBus
import com.example.sound_detective.model.SoundEvent
import com.example.sound_detective.model.SoundEventCategory
import com.example.sound_detective.model.SoundEventTier
import com.example.sound_detective.util.PackageLabelResolver

/** `MediaSessionManager.getActiveSessions` requires an enabled
 * notification-listener component, so this only attaches from
 * [DetectiveNotificationListenerService.onListenerConnected] — it
 * can't run standalone. */
object MediaSessionCollector {
    private var manager: MediaSessionManager? = null
    private var sessionsListener: MediaSessionManager.OnActiveSessionsChangedListener? = null
    private val controllers = mutableMapOf<MediaSession.Token, MediaController>()
    private val callbacks = mutableMapOf<MediaSession.Token, MediaController.Callback>()

    fun attach(listenerService: NotificationListenerService) {
        val context = listenerService.applicationContext
        val sessionManager =
            context.getSystemService(Context.MEDIA_SESSION_SERVICE) as MediaSessionManager
        manager = sessionManager
        val componentName = ComponentName(context, listenerService::class.java)

        val listener = MediaSessionManager.OnActiveSessionsChangedListener { sessions ->
            onSessionsChanged(context, sessions ?: emptyList())
        }
        sessionsListener = listener
        sessionManager.addOnActiveSessionsChangedListener(listener, componentName)
        onSessionsChanged(context, sessionManager.getActiveSessions(componentName))
    }

    fun detach() {
        val listener = sessionsListener ?: return
        manager?.removeOnActiveSessionsChangedListener(listener)
        controllers.forEach { (token, controller) -> callbacks[token]?.let { controller.unregisterCallback(it) } }
        controllers.clear()
        callbacks.clear()
        sessionsListener = null
        manager = null
    }

    private fun onSessionsChanged(context: Context, sessions: List<MediaController>) {
        val currentTokens = sessions.map { it.sessionToken }.toSet()
        val iterator = controllers.entries.iterator()
        while (iterator.hasNext()) {
            val (token, controller) = iterator.next()
            if (token !in currentTokens) {
                callbacks[token]?.let { controller.unregisterCallback(it) }
                callbacks.remove(token)
                iterator.remove()
            }
        }

        for (controller in sessions) {
            val token = controller.sessionToken
            if (controllers.containsKey(token)) continue
            controllers[token] = controller

            val pkg = controller.packageName
            val label = PackageLabelResolver.labelFor(context, pkg)
            val callback = object : MediaController.Callback() {
                override fun onPlaybackStateChanged(state: PlaybackState?) {
                    publish(controller, pkg, label, state)
                }
            }
            controller.registerCallback(callback)
            callbacks[token] = callback
            publish(controller, pkg, label, controller.playbackState)
        }
    }

    private fun publish(controller: MediaController, pkg: String, label: String, state: PlaybackState?) {
        val subtype = when (state?.state) {
            PlaybackState.STATE_PLAYING -> "PLAYING"
            PlaybackState.STATE_PAUSED -> "PAUSED"
            PlaybackState.STATE_STOPPED -> "STOPPED"
            else -> "UNKNOWN"
        }
        val title = controller.metadata?.getString(MediaMetadata.METADATA_KEY_TITLE)
        EventBus.publish(
            SoundEvent(
                category = SoundEventCategory.MEDIA_SESSION,
                tier = SoundEventTier.B,
                subtype = subtype,
                sourceLabel = label,
                packageName = pkg,
                appName = label,
                metadata = mapOf("title" to title),
            ),
        )
    }
}
