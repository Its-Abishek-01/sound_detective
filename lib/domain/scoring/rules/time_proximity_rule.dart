import '../../../data/models/sound_event.dart';
import '../scoring_config.dart';
import 'rule.dart';

/// The core scoring signal: how much weight a candidate's events
/// contribute, decayed linearly by how long ago each happened.
/// Every event is scored individually (base category weight × time
/// decay × audibility factor) and the candidate gets its single best
/// event's score — so one strong fresh signal isn't diluted or
/// double-counted by weaker ones. The category-specific rules
/// (notification/media/audio) add *reasons* and bonuses, not base
/// points.
class TimeProximityRule implements ScoringRule {
  @override
  RuleContribution evaluate(CandidateContext context) {
    var best = 0.0;
    SoundEvent? bestEvent;
    final windowSeconds = ScoringConfig.analysisWindow.inSeconds;

    for (final event in context.candidateEvents) {
      final baseWeight = ScoringConfig.categoryBaseWeight[event.category];
      if (baseWeight == null) continue;

      final secondsAgo =
          (context.analysisTime.millisecondsSinceEpoch - event.timestampMs) /
          1000;
      final decay = (1 - (secondsAgo / windowSeconds)).clamp(0.0, 1.0);

      var score = baseWeight * decay;
      if (event.category == SoundEventCategory.notificationPosted &&
          event.metadata['audible'] == false) {
        score *= ScoringConfig.silentNotificationFactor;
      }
      if (score > best) {
        best = score;
        bestEvent = event;
      }
    }

    return best <= 0 || bestEvent == null
        ? RuleContribution.none
        : RuleContribution(best, null, _labelFor(bestEvent));
  }

  String _labelFor(SoundEvent event) {
    return switch (event.category) {
      SoundEventCategory.notificationPosted => 'Recent notification',
      SoundEventCategory.mediaSession => 'Recent media activity',
      SoundEventCategory.audioPlaybackState => 'Recent audio activity',
      SoundEventCategory.audioFocus => 'Recent audio focus',
      SoundEventCategory.bluetooth => 'Recent Bluetooth event',
      SoundEventCategory.usb => 'Recent USB event',
      SoundEventCategory.headphones => 'Recent headphone event',
      SoundEventCategory.alarmClock => 'Recent alarm signal',
      SoundEventCategory.battery => 'Recent battery event',
      SoundEventCategory.volume => 'Recent volume change',
      SoundEventCategory.dnd => 'Recent DND change',
      SoundEventCategory.wifi => 'Recent Wi-Fi change',
      SoundEventCategory.mobileNetwork => 'Recent network change',
      _ => 'Recent device event',
    };
  }
}
