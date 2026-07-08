import 'package:flutter/services.dart';

import '../core/constants/channel_names.dart';
import '../data/models/sound_event.dart';
import 'service_status.dart';

/// Thin wrapper around the platform channels. Nothing here holds
/// business logic — it only translates between Dart types and the
/// raw channel payloads.
class NativeBridge {
  NativeBridge({
    MethodChannel? control,
    EventChannel? events,
    EventChannel? serviceStatus,
  })  : _control = control ?? const MethodChannel(ChannelNames.control),
        _events = events ?? const EventChannel(ChannelNames.events),
        _serviceStatus =
            serviceStatus ?? const EventChannel(ChannelNames.serviceStatus);

  final MethodChannel _control;
  final EventChannel _events;
  final EventChannel _serviceStatus;

  Stream<SoundEvent>? _eventStream;
  Stream<ServiceStatus>? _serviceStatusStream;

  Stream<SoundEvent> get eventStream {
    return _eventStream ??= _events.receiveBroadcastStream().map((raw) {
      final map = raw as Map<dynamic, dynamic>;
      return SoundEvent.fromChannelMap(map['event'] as Map<dynamic, dynamic>);
    });
  }

  Stream<ServiceStatus> get serviceStatusStream {
    return _serviceStatusStream ??= _serviceStatus
        .receiveBroadcastStream()
        .map((raw) => serviceStatusFromWire(raw as String));
  }

  Future<void> startForegroundService() =>
      _control.invokeMethod(ControlMethods.startForegroundService);

  Future<void> stopForegroundService() =>
      _control.invokeMethod(ControlMethods.stopForegroundService);

  Future<bool> isServiceRunning() async =>
      (await _control.invokeMethod<bool>(ControlMethods.isServiceRunning)) ??
      false;

  Future<bool> checkNotificationAccessGranted() async =>
      (await _control.invokeMethod<bool>(
        ControlMethods.checkNotificationAccessGranted,
      )) ??
      false;

  Future<void> openNotificationAccessSettings() =>
      _control.invokeMethod(ControlMethods.openNotificationAccessSettings);

  Future<bool> checkUsageAccessGranted() async =>
      (await _control.invokeMethod<bool>(
        ControlMethods.checkUsageAccessGranted,
      )) ??
      false;

  Future<void> openUsageAccessSettings() =>
      _control.invokeMethod(ControlMethods.openUsageAccessSettings);

  Future<bool> checkBluetoothPermissionGranted() async =>
      (await _control.invokeMethod<bool>(
        ControlMethods.checkBluetoothPermissionGranted,
      )) ??
      false;

  Future<void> requestBluetoothPermission() =>
      _control.invokeMethod(ControlMethods.requestBluetoothPermission);

  Future<bool> checkBatteryOptimizationExempt() async =>
      (await _control.invokeMethod<bool>(
        ControlMethods.checkBatteryOptimizationExempt,
      )) ??
      false;

  Future<void> requestBatteryOptimizationExemption() => _control.invokeMethod(
        ControlMethods.requestBatteryOptimizationExemption,
      );

  /// Backfills events the native ring buffer collected while the
  /// Flutter engine wasn't attached to listen on [eventStream].
  Future<List<SoundEvent>> getRecentEvents(int sinceMs) async {
    final raw = await _control.invokeMethod<List<dynamic>>(
      ControlMethods.getRecentEvents,
      {'sinceMs': sinceMs},
    );
    if (raw == null) return const [];
    return raw
        .map((e) => SoundEvent.fromChannelMap(e as Map<dynamic, dynamic>))
        .toList();
  }

  /// Returns and clears the pending launch action ("analyze" when the
  /// app was opened via the Quick Settings tile), or null. Pull-based:
  /// call after first frame and on every app resume.
  Future<String?> consumeLaunchAction() =>
      _control.invokeMethod<String>(ControlMethods.consumeLaunchAction);

  /// Current ringer mode: "NORMAL", "VIBRATE", or "SILENT".
  Future<String?> getCurrentRingerMode() =>
      _control.invokeMethod<String>(ControlMethods.getCurrentRingerMode);

  /// Triggers Tier C foreground-app reconstruction for the given
  /// lookback window; the resulting events also arrive on
  /// [eventStream] like any other collector.
  Future<void> reconstructForegroundApp(int windowStartMs, int windowEndMs) {
    return _control.invokeMethod(ControlMethods.reconstructForegroundApp, {
      'windowStartMs': windowStartMs,
      'windowEndMs': windowEndMs,
    });
  }
}
