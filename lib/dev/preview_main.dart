// Throwaway preview entrypoint — NOT the app's real main.dart. Lets us
// look at the glassmorphism UI in a browser without going through real
// platform channels (which don't exist on web/desktop). Not referenced
// by pubspec/android/ios build configs.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import '../data/models/sound_event.dart';
import '../domain/scoring/models/analysis_result.dart';
import '../features/detective/detective_controller.dart';
import '../features/detective/detective_screen.dart';
import '../features/detective/service_status_provider.dart';
import '../features/onboarding/permission_setup_flow.dart';
import '../features/onboarding/permission_status_provider.dart';
import '../features/timeline/timeline_controller.dart';
import '../platform/service_status.dart';
import '../shared/theme/app_colors.dart';
import '../shared/theme/app_spacing.dart';
import '../shared/theme/app_theme.dart';
import '../shared/widgets/glass_container.dart';
import '../shared/widgets/glass_scaffold.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        eventIngestionProvider.overrideWith((ref) {}),
        serviceStatusProvider.overrideWith(
          (ref) => Stream.value(ServiceStatus.started),
        ),
        permissionStatusProvider.overrideWith(
          (ref) async => const PermissionStatus(
            notificationAccess: true,
            usageAccess: true,
            bluetooth: true,
            batteryOptimizationExempt: true,
          ),
        ),
        detectiveProvider.overrideWith(_FakeDetectiveNotifier.new),
        timelineProvider.overrideWith((ref) => Stream.value(_fakeEvents())),
      ],
      child: const _PreviewApp(),
    ),
  );
}

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Detective Preview',
      theme: buildAppTheme(),
      home: const _PreviewGallery(),
    );
  }
}

class _PreviewGallery extends StatelessWidget {
  const _PreviewGallery();

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      title: 'Preview gallery',
      body: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight + AppSpacing.lg),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Screens',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _navButton(
                    context,
                    'Detective screen (with result)',
                    const DetectiveScreen(),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _navButton(
                    context,
                    'Onboarding flow',
                    PermissionSetupFlow(onComplete: () {}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(BuildContext context, String label, Widget target) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => target)),
        child: Text(label),
      ),
    );
  }
}

class _FakeDetectiveNotifier extends DetectiveNotifier {
  @override
  AnalysisResult? build() {
    return AnalysisResult(
      isUnknown: false,
      analyzedAt: DateTime.now(),
      sourceLabel: 'WhatsApp',
      packageName: 'com.whatsapp',
      confidence: 0.94,
      reasons: const [
        'Notification posted by WhatsApp',
        'WhatsApp was in the foreground',
      ],
      deviceState: const DeviceStateSnapshot(
        screenOn: false,
        audioStreamLabel: 'Notification',
        foregroundAppPackage: 'com.whatsapp',
      ),
    );
  }
}

List<SoundEvent> _fakeEvents() {
  final now = DateTime.now();
  return [
    SoundEvent(
      id: '1',
      timestampMs: now.millisecondsSinceEpoch,
      category: SoundEventCategory.notificationPosted,
      tier: SoundEventTier.b,
      subtype: 'POSTED',
      sourceLabel: 'WhatsApp',
      packageName: 'com.whatsapp',
    ),
    SoundEvent(
      id: '2',
      timestampMs: now.subtract(const Duration(minutes: 4)).millisecondsSinceEpoch,
      category: SoundEventCategory.bluetooth,
      tier: SoundEventTier.a,
      subtype: 'CONNECTED',
      sourceLabel: 'Pixel Buds',
    ),
    SoundEvent(
      id: '3',
      timestampMs: now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
      category: SoundEventCategory.usb,
      tier: SoundEventTier.a,
      subtype: 'CONNECTED',
      sourceLabel: 'USB',
    ),
  ];
}
