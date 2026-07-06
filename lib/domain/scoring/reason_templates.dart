/// Templated, human-readable reason strings — kept in one place so the
/// tone stays consistent and rules don't hand-build prose.
class ReasonTemplates {
  ReasonTemplates._();

  static String notificationPosted(String label) =>
      'Notification posted by $label';

  static String mediaPlaying(String label) => '$label is active in background';

  static String audioPlaybackActive(String label) =>
      '$label is playing audio right now';

  static String foregroundAppMatch(String label) =>
      '$label was in the foreground';

  static String systemEvent(String label, String subtype) =>
      '$label: $subtype';

  static String timeProximity(int secondsAgo) =>
      secondsAgo <= 1 ? 'Happened just now' : 'Happened $secondsAgo seconds ago';
}
