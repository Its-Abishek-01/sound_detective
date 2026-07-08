import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/models/sound_event.dart';
import '../../domain/scoring/models/analysis_result.dart';
import '../../domain/scoring/scoring_config.dart';
import '../../domain/scoring/scoring_engine.dart';
import '../../platform/native_bridge.dart';

final scoringEngineProvider = Provider<ScoringEngine>((ref) => ScoringEngine());

/// Drives one "I JUST HEARD A SOUND" analysis run: triggers Tier C
/// foreground-app reconstruction, pulls the last [ScoringConfig.analysisWindow]
/// of events, and runs them through the [ScoringEngine].
class DetectiveNotifier extends AsyncNotifier<AnalysisResult?> {
  @override
  AnalysisResult? build() => null;

  Future<void> analyzeNow() async {
    state = const AsyncLoading();
    final bridge = ref.read(nativeBridgeProvider);
    final repository = ref.read(eventRepositoryProvider);
    final engine = ref.read(scoringEngineProvider);

    final now = DateTime.now();
    final windowStart = now.subtract(ScoringConfig.analysisWindow);

    state = await AsyncValue.guard(() async {
      await bridge.reconstructForegroundApp(
        windowStart.millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
      );
      // Tier C reconstruction round-trips through the EventChannel
      // before landing in the DB; give it a moment to arrive.
      await Future.delayed(const Duration(milliseconds: 300));

      final events = await repository.eventsSince(
        windowStart.millisecondsSinceEpoch,
      );

      // The RINGER receiver only records mode *changes*, which usually
      // predate the analysis window — so snapshot the current mode now
      // and inject it as a synthetic context event. Not persisted; it
      // exists only for this analysis run.
      final ringerMode = await _currentRingerMode(bridge);
      if (ringerMode != null) {
        events.add(
          SoundEvent(
            id: 'synthetic-ringer-${now.millisecondsSinceEpoch}',
            timestampMs: now.millisecondsSinceEpoch,
            category: SoundEventCategory.ringer,
            tier: SoundEventTier.a,
            subtype: ringerMode,
            sourceLabel: 'Ringer mode',
          ),
        );
      }

      final result = engine.analyze(events, now);
      // Fire-and-forget: history is a convenience, never worth
      // failing the analysis over.
      unawaited(
        ref
            .read(historyRepositoryProvider)
            .saveResult(result)
            .catchError((_) {}),
      );
      return result;
    });
  }

  Future<String?> _currentRingerMode(NativeBridge bridge) async {
    try {
      return await bridge.getCurrentRingerMode();
    } catch (_) {
      return null; // Best-effort context; never fail the analysis.
    }
  }

  void reset() => state = const AsyncData(null);
}

final detectiveProvider =
    AsyncNotifierProvider<DetectiveNotifier, AnalysisResult?>(
  DetectiveNotifier.new,
);
