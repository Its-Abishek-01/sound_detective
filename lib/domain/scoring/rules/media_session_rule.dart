import '../../../data/models/sound_event.dart';
import '../reason_templates.dart';
import '../scoring_config.dart';
import 'rule.dart';

/// Rewards a candidate whose media session is actively PLAYING (not
/// just present/paused) with a bonus on top of the base
/// [TimeProximityRule] contribution — an actively playing session is a
/// stronger signal than a stale one.
class MediaSessionRule implements ScoringRule {
  @override
  RuleContribution evaluate(CandidateContext context) {
    final mediaEvents = context.candidateEvents.where(
      (e) => e.category == SoundEventCategory.mediaSession,
    );
    if (mediaEvents.isEmpty) return RuleContribution.none;

    final label = mediaEvents.first.sourceLabel;
    final isPlaying = mediaEvents.any(
      (e) => e.subtype.toUpperCase() == 'PLAYING',
    );
    final points = isPlaying ? ScoringConfig.mediaPlayingBonus : 0.0;
    return RuleContribution(
      points,
      ReasonTemplates.mediaPlaying(label),
      'Playing media bonus',
    );
  }
}
