/// Templated, human-readable reason strings — kept in one place so the
/// tone stays consistent and rules don't hand-build prose.
class ReasonTemplates {
  ReasonTemplates._();

  static String notificationPosted(String label) =>
      'Notification posted by $label';

  static String silentNotificationPosted(String label) =>
      'Silent notification posted by $label (no sound expected)';

  static String mediaPlaying(String label) => '$label is active in background';

  static String audioPlaybackActive(String label) =>
      '$label is playing audio right now';

  /// Used when the audio signal can't be attributed to a specific app
  /// (see AudioFocusAndPlaybackCollector's documented API limitation) —
  /// phrased so it doesn't read as a confident claim about which app.
  static String unattributedAudioPlaybackActive(String label) =>
      '$label detected nearby (source app can\'t be confirmed)';

  static String foregroundAppMatch(String label) =>
      '$label was in the foreground';

  static String systemEvent(String label, String subtype) =>
      '$label: $subtype';

  static String timeProximity(int secondsAgo) =>
      secondsAgo <= 1 ? 'Happened just now' : 'Happened $secondsAgo seconds ago';
}
