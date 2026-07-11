import '../../data/models/sound_event.dart';

/// All tunable weights/thresholds for the scoring engine, centralized
/// so behavior can be adjusted without touching rule logic.
class ScoringConfig {
  ScoringConfig._();

  /// How far back Detective Mode looks when the user presses the button.
  static const Duration analysisWindow = Duration(seconds: 30);

  /// A candidate below this fraction of [maxPossibleScore] is not
  /// confident enough to report — the result becomes "Unknown" instead.
  static const double minConfidenceFraction = 0.20;

  /// Confidence floor specifically for a top candidate that's
  /// unattributed audio (audioPlaybackState/audioFocus with no
  /// packageName — see AudioFocusAndPlaybackCollector's documented API
  /// limitation: it can never name an app). None of the app-attribution
  /// bonus rules (media session, foreground match) can apply without a
  /// packageName, so a pure unattributed-audio candidate's hard ceiling
  /// under the current rule set is ~26% — below this floor. In practice
  /// that means it always defers to Unknown rather than presenting an
  /// unverifiable "Alarm-type audio" guess as a confident headline
  /// answer. Kept as a real, tunable threshold (not a hardcoded
  /// exclusion) so it stays honest if future signals ever let an
  /// unattributed candidate corroborate further.
  static const double unattributedAudioMinConfidenceFraction = 0.30;

  /// Confidence is capped below 100% — certainty always leaves room for
  /// the possibility of an untracked cause.
  static const double maxConfidence = 0.97;

  /// Base "how loud a signal is this category, on its own" weight.
  /// Categories not eligible to be a standalone candidate (context-only)
  /// are omitted here — see [contextOnlyCategories].
  static const Map<SoundEventCategory, double> categoryBaseWeight = {
    SoundEventCategory.notificationPosted: 50,
    SoundEventCategory.mediaSession: 45,
    SoundEventCategory.usb: 40,
    // Unattributed — can't name an app (see AudioFocusAndPlaybackCollector),
    // so it's deliberately weighted below every named/verifiable signal.
    // Still useful as a fallback when nothing else is around.
    SoundEventCategory.audioPlaybackState: 22,
    SoundEventCategory.audioFocus: 18,
    SoundEventCategory.bluetooth: 35,
    SoundEventCategory.headphones: 35,
    SoundEventCategory.alarmClock: 30,
    SoundEventCategory.battery: 20,
    SoundEventCategory.volume: 15,
    SoundEventCategory.dnd: 10,
    SoundEventCategory.wifi: 10,
    SoundEventCategory.mobileNetwork: 10,
  };

  /// Categories that only ever decorate a result (device-state context
  /// or cross-referencing) and never form a candidate of their own.
  static const Set<SoundEventCategory> contextOnlyCategories = {
    SoundEventCategory.screen,
    SoundEventCategory.rotation,
    SoundEventCategory.foregroundApp,
    SoundEventCategory.notificationRemoved,
    SoundEventCategory.ringer,
  };

  static const double mediaPlayingBonus = 15;
  static const double foregroundAppMatchBonus = 20;

  /// Multiplier applied to a notification event the native listener
  /// judged as silent (low-importance channel, no channel sound, group
  /// summary, ongoing/foreground-service post). Silent notifications
  /// are visible but made no noise, so they should rarely win over a
  /// signal that actually produced sound.
  static const double silentNotificationFactor = 0.25;

  /// Sum of every rule's maximum possible contribution — the
  /// denominator confidence is normalized against. Kept fixed (not
  /// relative to other candidates in a given run) so confidence numbers
  /// stay stable regardless of what else happened nearby.
  static double get maxPossibleScore {
    final maxCategoryWeight = categoryBaseWeight.values.reduce(
      (a, b) => a > b ? a : b,
    );
    return maxCategoryWeight + mediaPlayingBonus + foregroundAppMatchBonus;
  }
}
