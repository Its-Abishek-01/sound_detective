import '../../../data/models/sound_event.dart';
import 'analysis_result.dart';

/// One candidate "likely source" under consideration, with the reasons
/// that contributed to its score.
class ScoredCandidate {
  ScoredCandidate({
    required this.key,
    required this.sourceLabel,
    required this.packageName,
    required this.primaryEvent,
    required this.rawScore,
  })  : reasons = [],
        scoreBreakdown = [];

  final String key;
  final String sourceLabel;
  final String? packageName;

  /// The single most representative event for this candidate (used for
  /// timestamp/subtype display).
  final SoundEvent primaryEvent;

  double rawScore;
  final List<String> reasons;
  final List<ScoreBreakdownItem> scoreBreakdown;

  void addContribution(double points, String? reason, {String? label}) {
    rawScore += points;
    if (reason != null) reasons.add(reason);
    if (label != null && points > 0) {
      scoreBreakdown.add(
        ScoreBreakdownItem(label: label, points: points, detail: reason),
      );
    }
  }
}
