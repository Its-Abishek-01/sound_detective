import '../../../data/models/sound_event.dart';

/// Everything a rule needs to score one candidate.
class CandidateContext {
  const CandidateContext({
    required this.key,
    required this.packageName,
    required this.candidateEvents,
    required this.allWindowEvents,
    required this.analysisTime,
  });

  /// `packageName`, or `system:<CATEGORY>` for candidates with no app
  /// (e.g. a bare USB-connected event).
  final String key;
  final String? packageName;

  /// This candidate's own events within the analysis window.
  final List<SoundEvent> candidateEvents;

  /// Every event in the window, regardless of candidate — used for
  /// cross-referencing (e.g. matching against the foreground app).
  final List<SoundEvent> allWindowEvents;

  final DateTime analysisTime;
}

class RuleContribution {
  const RuleContribution(this.points, [this.reason]);

  static const RuleContribution none = RuleContribution(0);

  final double points;
  final String? reason;
}

abstract class ScoringRule {
  RuleContribution evaluate(CandidateContext context);
}
