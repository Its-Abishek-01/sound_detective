import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sound_detective/app/providers.dart';
import 'package:sound_detective/features/detective/service_status_provider.dart';
import 'package:sound_detective/features/onboarding/permission_status_provider.dart';
import 'package:sound_detective/main.dart';
import 'package:sound_detective/platform/service_status.dart';

void main() {
  testWidgets('shows the Detective screen once permissions are granted', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Avoid touching real platform channels in a widget test.
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
        ],
        child: const SoundDetectiveApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sound Detective'), findsOneWidget);
    expect(find.text('I JUST HEARD\nA SOUND'), findsOneWidget);
  });
}
