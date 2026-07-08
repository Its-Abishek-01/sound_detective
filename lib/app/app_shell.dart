import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/detective/detective_screen.dart';
import '../features/onboarding/permission_setup_flow.dart';
import '../features/onboarding/permission_status_provider.dart';
import '../shared/theme/app_colors.dart';
import '../shared/widgets/gradient_background.dart';
import 'providers.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Starts native-event ingestion into the local DB as soon as the
    // app is up, independent of onboarding state.
    ref.watch(eventIngestionProvider);

    final statusAsync = ref.watch(permissionStatusProvider);

    return statusAsync.when(
      loading: () => Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.blobCyan),
          ),
        ),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: Center(
            child: Text(
              'Startup error: $err',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
      data: (status) {
        if (!status.requiredGranted) {
          return PermissionSetupFlow(
            onComplete: () => ref.invalidate(permissionStatusProvider),
          );
        }
        return const DetectiveScreen();
      },
    );
  }
}
