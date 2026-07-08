import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../platform/native_bridge.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/widgets/glass_container.dart';
import '../../shared/widgets/gradient_background.dart';
import '../../shared/widgets/gradient_cta_button.dart';
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
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              if (_step != _Step.intro) ...[
                const SizedBox(height: AppSpacing.lg),
                _StepDots(step: _step),
              ],
              Expanded(
                child: Center(
                  child: statusAsync.when(
                    loading: () => const CircularProgressIndicator(
                      color: AppColors.blobCyan,
                    ),
                    error: (err, _) => Text(
                      'Could not read permission status: $err',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    data: (status) => _buildStep(status, bridge),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(PermissionStatus status, NativeBridge bridge) {
    switch (_step) {
      case _Step.intro:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientCtaButton(
                onPressed: null,
                size: 120,
                child: const Icon(
                  Icons.search_rounded,
                  size: 52,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Sound Detective needs\na few permissions',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'To identify what caused a sound, it needs to see '
                'notifications, media playback, and app activity in the '
                'background. This only takes a minute to set up.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _advance(_Step.notificationAccess),
                  child: const Text('Get started'),
                ),
              ),
            ],
          ),
        );

      case _Step.notificationAccess:
        return PermissionStepWidget(
          icon: Icons.notifications_active_rounded,
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
          icon: Icons.apps_rounded,
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
          icon: Icons.bluetooth_rounded,
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
          icon: Icons.battery_saver_rounded,
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

class _StepDots extends StatelessWidget {
  const _StepDots({required this.step});

  final _Step step;

  @override
  Widget build(BuildContext context) {
    final steps = [
      _Step.notificationAccess,
      _Step.usageAccess,
      _Step.bluetooth,
      _Step.battery,
    ];
    final activeIndex = steps.indexOf(step);

    return GlassContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      borderRadius: AppSpacing.radiusPill,
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < steps.length; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == activeIndex ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i <= activeIndex
                    ? AppColors.blobCyan
                    : AppColors.textTertiary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
            ),
        ],
      ),
    );
  }
}
