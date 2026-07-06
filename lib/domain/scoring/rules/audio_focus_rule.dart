import '../../../data/models/sound_event.dart';
import '../reason_templates.dart';
import 'rule.dart';

/// Adds the causal reason bullet when a candidate holds active audio
/// playback (surfaced to the user as "Audio Focus changed", though the
/// underlying native signal is `AudioManager.AudioPlaybackCallback`,
/// not a focus-change broadcast — see AudioFocusAndPlaybackCollector).
class AudioFocusRule implements ScoringRule {
  @override
  RuleContribution evaluate(CandidateContext context) {
    final audioEvents = context.candidateEvents.where(
      (e) =>
          e.category == SoundEventCategory.audioFocus ||
          e.category == SoundEventCategory.audioPlaybackState,
    );
    if (audioEvents.isEmpty) return RuleContribution.none;

    final label = audioEvents.first.sourceLabel;
    return RuleContribution(0, ReasonTemplates.audioPlaybackActive(label));
  }
}
