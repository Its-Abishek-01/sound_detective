import '../../../data/models/sound_event.dart';
import '../reason_templates.dart';
import 'rule.dart';

/// Adds the causal reason bullet when a notification was posted — the
/// base score contribution for this signal already comes from
/// [TimeProximityRule]; this rule only explains *why*. If every
/// notification in the window was silent, the reason says so instead
/// of implying the notification made the sound.
class NotificationPresenceRule implements ScoringRule {
  @override
  RuleContribution evaluate(CandidateContext context) {
    final notifications = context.candidateEvents
        .where((e) => e.category == SoundEventCategory.notificationPosted)
        .toList();
    if (notifications.isEmpty) return RuleContribution.none;

    final audible = notifications.where(
      (e) => e.metadata['audible'] != false,
    );
    if (audible.isNotEmpty) {
      return RuleContribution(
        0,
        ReasonTemplates.notificationPosted(audible.first.sourceLabel),
      );
    }
    return RuleContribution(
      0,
      ReasonTemplates.silentNotificationPosted(notifications.first.sourceLabel),
    );
  }
}
