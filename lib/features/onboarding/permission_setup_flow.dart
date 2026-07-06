import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../platform/native_bridge.dart';
import 'permission_status_provider.dart';
import 'permission_step_widget.dart';

enum _Step { intro, notificationAccess, usageAccess, bluetooth, battery }

/// First-launch-only stepper that walks the user through every
/// permission the background collectors need. Each step is a
/// round-trip to a system Settings screen, so grant status is
/// re-checked whenever the app resumes.
class PermissionSetupFlow extends ConsumerStatefulWidget {
  const PermissionSetupFlow({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  ConsumerState<PermissionSetupFlow> createState() =>
      _PermissionSetupFlowState();
}

class _PermissionSetupFlowState extends ConsumerState<PermissionSetupFlow>
    with WidgetsBindingObserver {
  _Step _step = _Step.intro;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(permissionStatusProvider);
    }
  }

  void _advance(_Step next) => setState(() => _step = next);

  @override
  Widget build(BuildContext context) {
    final bridge = ref.watch(nativeBridgeProvider);
    final statusAsync = ref.watch(permissionStatusProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: statusAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (err, _) => Text('Could not read permission status: $err'),
            data: (status) => _buildStep(status, bridge),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(PermissionStatus status, NativeBridge bridge) {
    switch (_step) {
      case _Step.intro:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search, size: 72),
              const SizedBox(height: 24),
              Text(
                'Sound Detective needs a few permissions',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'To identify what caused a sound, it needs to see '
                'notifications, media playback, and app activity in the '
                'background. This only takes a minute to set up.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => _advance(_Step.notificationAccess),
                child: const Text('Get started'),
              ),
            ],
          ),
        );

      case _Step.notificationAccess:
        return PermissionStepWidget(
          icon: Icons.notifications_active_outlined,
          title: 'Notification access',
          description:
              'Lets Sound Detective see which app posted a notification, '
              'and what\'s currently playing media — the core signal for '
              'identifying most sounds.',
          granted: status.notificationAccess,
          grantButtonLabel: 'Open settings',
          onGrant: bridge.openNotificationAccessSettings,
          onContinue: () => _advance(_Step.usageAccess),
        );

      case _Step.usageAccess:
        return PermissionStepWidget(
          icon: Icons.apps_outlined,
          title: 'Usage access',
          description:
              'Lets Sound Detective identify which app was in the '
              'foreground right before a sound happened.',
          granted: status.usageAccess,
          grantButtonLabel: 'Open settings',
          onGrant: bridge.openUsageAccessSettings,
          onContinue: () => _advance(_Step.bluetooth),
        );

      case _Step.bluetooth:
        return PermissionStepWidget(
          icon: Icons.bluetooth,
          title: 'Bluetooth',
          description:
              'Lets Sound Detective detect Bluetooth device connect/'
              'disconnect events as a possible sound source.',
          granted: status.bluetooth,
          grantButtonLabel: 'Allow',
          onGrant: bridge.requestBluetoothPermission,
          onContinue: () => _advance(_Step.battery),
        );

      case _Step.battery:
        return PermissionStepWidget(
          icon: Icons.battery_saver_outlined,
          title: 'Run reliably in the background',
          description:
              'Exempting Sound Detective from battery optimization keeps '
              'it listening even when the screen is off. Optional, but '
              'recommended.',
          granted: status.batteryOptimizationExempt,
          grantButtonLabel: 'Open settings',
          optional: true,
          onGrant: bridge.requestBatteryOptimizationExemption,
          onContinue: () async {
            await bridge.startForegroundService();
            widget.onComplete();
          },
        );
    }
  }
}
