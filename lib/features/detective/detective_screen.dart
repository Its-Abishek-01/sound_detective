import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/scoring/models/analysis_result.dart';
import '../../platform/service_status.dart';
import '../timeline/timeline_screen.dart';
import 'detective_controller.dart';
import 'service_status_provider.dart';

class DetectiveScreen extends ConsumerWidget {
  const DetectiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultState = ref.watch(detectiveProvider);
    final statusAsync = ref.watch(serviceStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sound Detective'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Timeline',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TimelineScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _ListeningIndicator(statusAsync: statusAsync),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            listening ? Icons.podcasts : Icons.podcasts_outlined,
            size: 16,
            color: listening ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            listening ? 'Listening in the background' : 'Starting up…',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
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
        Text(
          'Heard a mysterious sound?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: 220,
          height: 220,
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(shape: const CircleBorder()),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'I JUST HEARD A SOUND',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 24),
        Text('Checking…', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        for (final label in _checks)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text('✓ $label'),
          ),
      ],
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text('Something went wrong: $message');
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, required this.onAskAgain});

  final AnalysisResult result;
  final VoidCallback onAskAgain;

  @override
  Widget build(BuildContext context) {
    if (result.isUnknown) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.help_outline, size: 48),
              const SizedBox(height: 12),
              Text(
                'Not sure this time',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Nothing in the last 30 seconds stood out as the cause.',
                textAlign: TextAlign.center,
              ),
              if (result.nearbyContextEvents.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const Text('Nearby activity:'),
                for (final e in result.nearbyContextEvents.take(5))
                  Text('• ${e.sourceLabel} — ${e.subtype}'),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onAskAgain,
                child: const Text('Check again'),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Likely Source',
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              result.sourceLabel ?? 'Unknown',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '${result.confidencePercent}% confidence',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.green),
            ),
            if (result.reasons.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Because', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              for (final reason in result.reasons)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('• $reason'),
                ),
            ],
            const SizedBox(height: 16),
            const Divider(),
            _MetadataRow(
              label: 'Audio Stream',
              value: result.deviceState.audioStreamLabel ?? 'Unknown',
            ),
            _MetadataRow(
              label: 'Foreground',
              value: result.deviceState.foregroundAppPackage == result.packageName
                  ? 'Yes'
                  : 'No',
            ),
            _MetadataRow(
              label: 'Device State',
              value: result.deviceState.screenOn == false
                  ? 'Screen Off'
                  : 'Screen On',
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onAskAgain,
              child: const Text('Check again'),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
