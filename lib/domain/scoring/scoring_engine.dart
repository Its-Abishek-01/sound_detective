import '../../data/models/sound_event.dart';
import 'models/analysis_result.dart';
import 'models/scored_candidate.dart';
import 'rules/audio_focus_rule.dart';
import 'rules/device_state_rule.dart';
import 'rules/foreground_app_rule.dart';
import 'rules/media_session_rule.dart';
import 'rules/notification_presence_rule.dart';
import 'rules/rule.dart';
import 'rules/time_proximity_rule.dart';
import 'scoring_config.dart';

/// Pure Dart, no platform dependency — takes an already-fetched window
/// of events and returns a ranked result. Fully unit-testable with
/// synthetic [SoundEvent] fixtures.
class ScoringEngine {
  ScoringEngine({List<ScoringRule>? rules})
      : _rules = rules ??
            [
              TimeProximityRule(),
              NotificationPresenceRule(),
              MediaSessionRule(),
              AudioFocusRule(),
              ForegroundAppRule(),
            ];

  final List<ScoringRule> _rules;

  AnalysisResult analyze(List<SoundEvent> windowEvents, DateTime analysisTime) {
    final sorted = [...windowEvents]
      ..sort((a, b) => b.timestampMs.compareTo(a.timestampMs));
    final deviceState = DeviceStateRule.extract(sorted);

    final candidates = _groupCandidates(sorted);
    final scored = <ScoredCandidate>[];

    for (final entry in candidates.entries) {
      final events = entry.value;
      final primaryEvent = events.reduce(
        (a, b) => a.timestampMs > b.timestampMs ? a : b,
      );
      final candidate = ScoredCandidate(
        key: entry.key,
        sourceLabel: primaryEvent.sourceLabel,
        packageName: primaryEvent.packageName,
        primaryEvent: primaryEvent,
        rawScore: 0,
      );

      final context = CandidateContext(
        key: entry.key,
        packageName: primaryEvent.packageName,
        candidateEvents: events,
        allWindowEvents: sorted,
        analysisTime: analysisTime,
      );

      for (final rule in _rules) {
        final contribution = rule.evaluate(context);
        candidate.addContribution(contribution.points, contribution.reason);
      }

      scored.add(candidate);
    }

    scored.sort((a, b) => b.rawScore.compareTo(a.rawScore));

    if (scored.isEmpty) {
      return AnalysisResult.unknown(
        analyzedAt: analysisTime,
        deviceState: deviceState,
        nearbyContextEvents: sorted,
      );
    }

    final top = scored.first;
    final confidence = (top.rawScore / ScoringConfig.maxPossibleScore).clamp(
      0.0,
      ScoringConfig.maxConfidence,
    );

    if (confidence < ScoringConfig.minConfidenceFraction) {
      return AnalysisResult.unknown(
        analyzedAt: analysisTime,
        deviceState: deviceState,
        nearbyContextEvents: sorted,
      );
    }

    return AnalysisResult(
      isUnknown: false,
      analyzedAt: analysisTime,
      sourceLabel: top.sourceLabel,
      packageName: top.packageName,
      confidence: confidence,
      reasons: top.reasons,
      event: top.primaryEvent,
      deviceState: deviceState,
    );
  }

  /// Groups events into candidates: events with a `packageName` are
  /// grouped per-app (so a notification and a media session from the
  /// same app compound into one candidate); events without one are
  /// grouped per-category as a standalone system-level candidate (e.g.
  /// "USB connected"). Context-only categories never form a candidate.
  Map<String, List<SoundEvent>> _groupCandidates(List<SoundEvent> events) {
    final map = <String, List<SoundEvent>>{};
    for (final event in events) {
      if (ScoringConfig.contextOnlyCategories.contains(event.category)) {
        continue;
      }
      final key = event.packageName != null
          ? 'pkg:${event.packageName}'
          : 'system:${event.category.wireName}';
      map.putIfAbsent(key, () => []).add(event);
    }
    return map;
  }
}
