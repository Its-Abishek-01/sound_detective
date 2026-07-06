import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';

class PermissionStatus {
  const PermissionStatus({
    required this.notificationAccess,
    required this.usageAccess,
    required this.bluetooth,
    required this.batteryOptimizationExempt,
  });

  final bool notificationAccess;
  final bool usageAccess;
  final bool bluetooth;
  final bool batteryOptimizationExempt;

  /// Battery optimization exemption is a "nice to have" for reliability,
  /// not required to use the app, so it's excluded from the gate that
  /// decides whether onboarding is complete.
  bool get requiredGranted => notificationAccess && usageAccess && bluetooth;
}

/// Re-read on demand (e.g. on app resume, or after returning from a
/// Settings screen) rather than cached — every check is a cheap native
/// call and grants can only change via the OS Settings UI anyway.
final permissionStatusProvider = FutureProvider<PermissionStatus>((
  ref,
) async {
  final bridge = ref.watch(nativeBridgeProvider);
  final results = await Future.wait([
    bridge.checkNotificationAccessGranted(),
    bridge.checkUsageAccessGranted(),
    bridge.checkBluetoothPermissionGranted(),
    bridge.checkBatteryOptimizationExempt(),
  ]);
  return PermissionStatus(
    notificationAccess: results[0],
    usageAccess: results[1],
    bluetooth: results[2],
    batteryOptimizationExempt: results[3],
  );
});
