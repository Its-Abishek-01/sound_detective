import '../../../data/models/sound_event.dart';

/// One candidate "likely source" under consideration, with the reasons
/// that contributed to its score.
class ScoredCandidate {
  ScoredCandidate({
    required this.key,
    required this.sourceLabel,
    required this.packageName,
    required this.primaryEvent,
    required this.rawScore,
  }) : reasons = [];

  final String key;
  final String sourceLabel;
  final String? packageName;

  /// The single most representative event for this candidate (used for
  /// timestamp/subtype display).
  final SoundEvent primaryEvent;

  double rawScore;
  final List<String> reasons;

  void addContribution(double points, String? reason) {
    rawScore += points;
    if (reason != null) reasons.add(reason);
  }
}
