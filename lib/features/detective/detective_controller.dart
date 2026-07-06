import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/scoring/models/analysis_result.dart';
import '../../domain/scoring/scoring_config.dart';
import '../../domain/scoring/scoring_engine.dart';

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
      return engine.analyze(events, now);
    });
  }

  void reset() => state = const AsyncData(null);
}

final detectiveProvider =
    AsyncNotifierProvider<DetectiveNotifier, AnalysisResult?>(
  DetectiveNotifier.new,
);
