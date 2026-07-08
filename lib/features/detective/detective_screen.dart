import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/scoring/models/analysis_result.dart';
import '../../platform/service_status.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/widgets/glass_container.dart';
import '../../shared/widgets/glass_scaffold.dart';
import '../../shared/widgets/gradient_cta_button.dart';
import '../timeline/timeline_screen.dart';
import 'detective_controller.dart';
import 'service_status_provider.dart';

class DetectiveScreen extends ConsumerStatefulWidget {
  const DetectiveScreen({super.key});

  @override
  ConsumerState<DetectiveScreen> createState() => _DetectiveScreenState();
}

class _DetectiveScreenState extends ConsumerState<DetectiveScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Cold start: the Quick Settings tile may have launched us with an
    // "analyze" action — check once the first frame is up.
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLaunchAction());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Warm start: tile tapped while the app was already alive in the
    // background — the activity resumes with a new pending action.
    if (state == AppLifecycleState.resumed) _checkLaunchAction();
  }

  Future<void> _checkLaunchAction() async {
    String? action;
    try {
      action = await ref.read(nativeBridgeProvider).consumeLaunchAction();
    } catch (_) {
      // Platform channel unavailable (tests, engine teardown) — the
      // tile shortcut is best-effort, never worth crashing over.
      return;
    }
    if (action == 'analyze' && mounted) {
      ref.read(detectiveProvider.notifier).analyzeNow();
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultState = ref.watch(detectiveProvider);
    final statusAsync = ref.watch(serviceStatusProvider);

    return GlassScaffold(
      title: 'Sound Detective',
      actions: [
        IconButton(
          icon: const Icon(Icons.history_rounded),
          tooltip: 'Timeline',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TimelineScreen()),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
      body: Column(
        children: [
          const SizedBox(height: kToolbarHeight + AppSpacing.sm),
          _ListeningIndicator(statusAsync: statusAsync),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: resultState.when(
                  loading: () => const _CheckingIndicator(),
                  error: (err, _) => _ErrorCard(message: '$err'),
                  data: (result) => result == null
                      ? _IdlePrompt(
                          onPressed: () => ref
                              .read(detectiveProvider.notifier)
                              .analyzeNow(),
                        )
                      : _ResultCard(
                          result: result,
                          onAskAgain: () => ref
                              .read(detectiveProvider.notifier)
                              .analyzeNow(),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListeningIndicator extends StatelessWidget {
  const _ListeningIndicator({required this.statusAsync});

  final AsyncValue<ServiceStatus> statusAsync;

  @override
  Widget build(BuildContext context) {
    final listening = statusAsync.maybeWhen(
      data: (s) =>
          s == ServiceStatus.started || s == ServiceStatus.listenerConnected,
      orElse: () => false,
    );
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        borderRadius: AppSpacing.radiusPill,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: listening ? AppColors.success : AppColors.textTertiary,
                boxShadow: listening
                    ? [
                        BoxShadow(
                          color: AppColors.success.withValues(alpha: 0.7),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              listening ? 'Listening in the background' : 'Starting up…',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdlePrompt extends StatelessWidget {
  const _IdlePrompt({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Heard a mysterious sound?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Tap below and we\'ll check the last 30 seconds.',
          style: TextStyle(color: AppColors.textTertiary, fontSize: 14),
        ),
        const SizedBox(height: AppSpacing.xxl),
        GradientCtaButton(
          onPressed: onPressed,
          child: const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Text(
              'I JUST HEARD\nA SOUND',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
                height: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckingIndicator extends StatelessWidget {
  const _CheckingIndicator();

  static const _checks = [
    'Notifications',
    'Media',
    'Bluetooth',
    'USB',
    'Foreground app',
  ];

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.blobCyan,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Checking…',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final label in _checks)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Text(
        'Something went wrong: $message',
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, required this.onAskAgain});

  final AnalysisResult result;
  final VoidCallback onAskAgain;

  @override
  Widget build(BuildContext context) {
    if (result.isUnknown) {
      return GlassContainer(
        strong: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.help_outline_rounded,
              size: 44,
              color: AppColors.warning,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Not sure this time',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Nothing in the last 30 seconds stood out as the cause.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            if (result.nearbyContextEvents.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.md),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nearby activity',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final e in result.nearbyContextEvents.take(5))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${e.sourceLabel} — ${e.subtype}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
            ],
            const SizedBox(height: AppSpacing.lg),
            _AskAgainButton(onPressed: onAskAgain),
          ],
        ),
      );
    }

    return GlassContainer(
      strong: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'LIKELY SOURCE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            result.sourceLabel ?? 'Unknown',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  size: 16,
                  color: AppColors.success,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${result.confidencePercent}% confidence',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (result.reasons.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'BECAUSE',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final reason in result.reasons)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.circle,
                        size: 5,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        reason,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),
          _MetadataRow(
            label: 'Audio Stream',
            value: result.deviceState.audioStreamLabel ?? 'Unknown',
          ),
          _MetadataRow(
            label: 'Foreground',
            value:
                result.deviceState.foregroundAppPackage == result.packageName
                ? 'Yes'
                : 'No',
          ),
          _MetadataRow(
            label: 'Device State',
            value: result.deviceState.screenOn == false
                ? 'Screen Off'
                : 'Screen On',
          ),
          if (result.deviceState.ringerMode != null)
            _MetadataRow(
              label: 'Ringer',
              value: switch (result.deviceState.ringerMode) {
                'VIBRATE' => 'Vibrate',
                'SILENT' => 'Silent',
                _ => 'Normal',
              },
            ),
          if (result.deviceState.wasMuted) ...[
            const SizedBox(height: AppSpacing.md),
            const _MutedNote(),
          ],
          const SizedBox(height: AppSpacing.lg),
          _AskAgainButton(onPressed: onAskAgain),
        ],
      ),
    );
  }
}

/// Shown when the phone was on vibrate/silent at analysis time — a
/// notification "sound" couldn't have rung, so what the user heard was
/// most likely a vibration buzz or a different device entirely.
class _MutedNote extends StatelessWidget {
  const _MutedNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.vibration_rounded, size: 18, color: AppColors.warning),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Your phone was muted — what you heard was likely a '
              'vibration, or came from another device.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AskAgainButton extends StatelessWidget {
  const _AskAgainButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        child: const Text('Check again'),
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
