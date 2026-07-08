/// Names for the platform channels shared between Dart and the native
/// Android side. Keep in sync with the Kotlin constants in
/// `android/app/src/main/kotlin/.../channel/ChannelNames.kt`.
class ChannelNames {
  ChannelNames._();

  static const String control = 'sounddetective/control';
  static const String events = 'sounddetective/events';
  static const String serviceStatus = 'sounddetective/service_status';
}

/// Method names used on [ChannelNames.control].
class ControlMethods {
  ControlMethods._();

  static const String startForegroundService = 'startForegroundService';
  static const String stopForegroundService = 'stopForegroundService';
  static const String isServiceRunning = 'isServiceRunning';

  static const String checkNotificationAccessGranted =
      'checkNotificationAccessGranted';
  static const String openNotificationAccessSettings =
      'openNotificationAccessSettings';

  static const String checkUsageAccessGranted = 'checkUsageAccessGranted';
  static const String openUsageAccessSettings = 'openUsageAccessSettings';

  static const String checkBluetoothPermissionGranted =
      'checkBluetoothPermissionGranted';
  static const String requestBluetoothPermission =
      'requestBluetoothPermission';

  static const String checkBatteryOptimizationExempt =
      'checkBatteryOptimizationExempt';
  static const String requestBatteryOptimizationExemption =
      'requestBatteryOptimizationExemption';

  static const String getRecentEvents = 'getRecentEvents';
  static const String reconstructForegroundApp = 'reconstructForegroundApp';
  static const String consumeLaunchAction = 'consumeLaunchAction';
  static const String getCurrentRingerMode = 'getCurrentRingerMode';
}
