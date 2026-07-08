import '../../../data/models/sound_event.dart';
import '../reason_templates.dart';
import '../scoring_config.dart';
import 'rule.dart';

/// Bonus for a candidate that was also the foreground app around the
/// time of the sound (Tier C, reconstructed via UsageStatsManager).
/// Cross-references [CandidateContext.allWindowEvents] rather than the
/// candidate's own events, since FOREGROUND_APP is a context-only
/// category (see [ScoringConfig.contextOnlyCategories]).
class ForegroundAppRule implements ScoringRule {
  @override
  RuleContribution evaluate(CandidateContext context) {
    final packageName = context.packageName;
    if (packageName == null) return RuleContribution.none;

    final match = context.allWindowEvents.where(
      (e) =>
          e.category == SoundEventCategory.foregroundApp &&
          e.packageName == packageName,
    );
    if (match.isEmpty) return RuleContribution.none;

    return RuleContribution(
      ScoringConfig.foregroundAppMatchBonus,
      ReasonTemplates.foregroundAppMatch(match.first.sourceLabel),
      'Foreground app match',
    );
  }
}
