import '../../../data/models/sound_event.dart';
import '../reason_templates.dart';
import 'rule.dart';

/// Adds the causal reason bullet when a notification was posted — the
/// base score contribution for this signal already comes from
/// [TimeProximityRule]; this rule only explains *why*.
class NotificationPresenceRule implements ScoringRule {
  @override
  RuleContribution evaluate(CandidateContext context) {
    final hasNotification = context.candidateEvents.any(
      (e) => e.category == SoundEventCategory.notificationPosted,
    );
    if (!hasNotification) return RuleContribution.none;

    final label = context.candidateEvents
        .firstWhere((e) => e.category == SoundEventCategory.notificationPosted)
        .sourceLabel;
    return RuleContribution(0, ReasonTemplates.notificationPosted(label));
  }
}
