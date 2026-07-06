import '../scoring_config.dart';
import 'rule.dart';

/// The core scoring signal: how much weight a candidate's most recent
/// event contributes, decayed linearly by how long ago it happened.
/// Applies uniformly across every category — the category-specific
/// rules (notification/media/audio) add *reasons*, not additional
/// base points, so a signal is never double-counted.
class TimeProximityRule implements ScoringRule {
  @override
  RuleContribution evaluate(CandidateContext context) {
    if (context.candidateEvents.isEmpty) return RuleContribution.none;

    final mostRecent = context.candidateEvents.reduce(
      (a, b) => a.timestampMs > b.timestampMs ? a : b,
    );
    final baseWeight = ScoringConfig.categoryBaseWeight[mostRecent.category];
    if (baseWeight == null) return RuleContribution.none;

    final secondsAgo =
        (context.analysisTime.millisecondsSinceEpoch - mostRecent.timestampMs) /
        1000;
    final windowSeconds = ScoringConfig.analysisWindow.inSeconds;
    final decay = (1 - (secondsAgo / windowSeconds)).clamp(0.0, 1.0);
    final points = baseWeight * decay;

    return points <= 0 ? RuleContribution.none : RuleContribution(points);
  }
}
