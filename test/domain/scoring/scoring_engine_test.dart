import 'package:flutter_test/flutter_test.dart';
import 'package:sound_detective/data/models/sound_event.dart';
import 'package:sound_detective/domain/scoring/scoring_engine.dart';

SoundEvent _event({
  required SoundEventCategory category,
  required int secondsAgo,
  DateTime? now,
  String? packageName,
  String sourceLabel = '',
  String subtype = '',
  Map<String, dynamic> metadata = const {},
}) {
  final base = now ?? DateTime.now();
  return SoundEvent(
    id: '${category.wireName}-$secondsAgo-${packageName ?? ''}',
    timestampMs: base
        .subtract(Duration(seconds: secondsAgo))
        .millisecondsSinceEpoch,
    category: category,
    tier: SoundEventTier.a,
    subtype: subtype,
    sourceLabel: sourceLabel,
    packageName: packageName,
    metadata: metadata,
  );
}

void main() {
  final now = DateTime(2026, 1, 1, 12, 0, 0);

  test('a fresh notification clearly wins over a stale system event', () {
    final events = [
      _event(
        category: SoundEventCategory.notificationPosted,
        secondsAgo: 1,
        now: now,
        packageName: 'com.whatsapp',
        sourceLabel: 'WhatsApp',
      ),
      _event(
        category: SoundEventCategory.wifi,
        secondsAgo: 25,
        now: now,
        sourceLabel: 'Wi-Fi',
      ),
    ];

    final result = ScoringEngine().analyze(events, now);

    expect(result.isUnknown, isFalse);
    expect(result.sourceLabel, 'WhatsApp');
    expect(result.packageName, 'com.whatsapp');
    expect(result.reasons, contains('Notification posted by WhatsApp'));
    expect(result.scoreBreakdown.first.label, 'Recent notification');
    expect(result.scoreBreakdown.first.points, greaterThan(0));
    expect(result.confidencePercent, greaterThan(50));
  });

  test(
      'unattributed alarm-type audio loses to a real named notification '
      'even when fresher', () {
    final events = [
      _event(
        category: SoundEventCategory.notificationPosted,
        secondsAgo: 8,
        now: now,
        packageName: 'com.whatsapp',
        sourceLabel: 'WhatsApp',
        metadata: {'audible': true},
      ),
      _event(
        category: SoundEventCategory.audioPlaybackState,
        secondsAgo: 1,
        now: now,
        sourceLabel: 'Alarm-type audio',
        subtype: 'PLAYING',
        metadata: {'streamType': 'Alarm-type audio', 'attributed': false},
      ),
    ];

    final result = ScoringEngine().analyze(events, now);

    expect(result.isUnknown, isFalse);
    expect(result.sourceLabel, 'WhatsApp');
  });

  test('a lone unattributed audio signal gets a hedged reason', () {
    final events = [
      _event(
        category: SoundEventCategory.audioPlaybackState,
        secondsAgo: 1,
        now: now,
        sourceLabel: 'Alarm-type audio',
        subtype: 'PLAYING',
        metadata: {'streamType': 'Alarm-type audio', 'attributed': false},
      ),
    ];

    final result = ScoringEngine().analyze(events, now);

    expect(result.isUnknown, isFalse);
    expect(
      result.reasons,
      contains("Alarm-type audio detected nearby (source app can't be confirmed)"),
    );
  });

  test('an empty window returns Unknown', () {
    final result = ScoringEngine().analyze(const [], now);

    expect(result.isUnknown, isTrue);
    expect(result.sourceLabel, isNull);
  });

  test('a single old, weak system event falls below the confidence floor', () {
    final events = [
      _event(
        category: SoundEventCategory.dnd,
        secondsAgo: 29,
        now: now,
        sourceLabel: 'Do Not Disturb',
      ),
    ];

    final result = ScoringEngine().analyze(events, now);

    expect(result.isUnknown, isTrue);
  });

  test('a silent notification loses to actively playing media', () {
    final events = [
      _event(
        category: SoundEventCategory.notificationPosted,
        secondsAgo: 1,
        now: now,
        packageName: 'com.slack',
        sourceLabel: 'Slack',
        metadata: {'audible': false},
      ),
      _event(
        category: SoundEventCategory.mediaSession,
        secondsAgo: 4,
        now: now,
        packageName: 'com.spotify.music',
        sourceLabel: 'Spotify',
        subtype: 'PLAYING',
      ),
    ];

    final result = ScoringEngine().analyze(events, now);

    expect(result.isUnknown, isFalse);
    expect(result.sourceLabel, 'Spotify');
  });

  test('an audible notification outscores an identical silent one', () {
    final events = [
      _event(
        category: SoundEventCategory.notificationPosted,
        secondsAgo: 2,
        now: now,
        packageName: 'com.whatsapp',
        sourceLabel: 'WhatsApp',
        metadata: {'audible': true},
      ),
      _event(
        category: SoundEventCategory.notificationPosted,
        secondsAgo: 2,
        now: now,
        packageName: 'com.slack',
        sourceLabel: 'Slack',
        metadata: {'audible': false},
      ),
    ];

    final result = ScoringEngine().analyze(events, now);

    expect(result.isUnknown, isFalse);
    expect(result.sourceLabel, 'WhatsApp');
    expect(result.reasons, contains('Notification posted by WhatsApp'));
  });

  test('a lone silent notification is reported honestly in the reason', () {
    final events = [
      _event(
        category: SoundEventCategory.notificationPosted,
        secondsAgo: 1,
        now: now,
        packageName: 'com.slack',
        sourceLabel: 'Slack',
        metadata: {'audible': false},
      ),
      _event(
        category: SoundEventCategory.mediaSession,
        secondsAgo: 3,
        now: now,
        packageName: 'com.slack',
        sourceLabel: 'Slack',
        subtype: 'PLAYING',
      ),
    ];

    final result = ScoringEngine().analyze(events, now);

    expect(result.isUnknown, isFalse);
    expect(
      result.reasons,
      contains('Silent notification posted by Slack (no sound expected)'),
    );
  });

  test('ringer mode lands in the device-state snapshot, not as a candidate',
      () {
    final events = [
      _event(
        category: SoundEventCategory.notificationPosted,
        secondsAgo: 1,
        now: now,
        packageName: 'com.whatsapp',
        sourceLabel: 'WhatsApp',
      ),
      _event(
        category: SoundEventCategory.ringer,
        secondsAgo: 0,
        now: now,
        sourceLabel: 'Ringer mode',
        subtype: 'VIBRATE',
      ),
    ];

    final result = ScoringEngine().analyze(events, now);

    expect(result.sourceLabel, 'WhatsApp');
    expect(result.deviceState.ringerMode, 'VIBRATE');
    expect(result.deviceState.wasMuted, isTrue);
  });

  test('a candidate with both notification and playing media compounds', () {
    final events = [
      _event(
        category: SoundEventCategory.notificationPosted,
        secondsAgo: 3,
        now: now,
        packageName: 'com.spotify.music',
        sourceLabel: 'Spotify',
      ),
      _event(
        category: SoundEventCategory.mediaSession,
        secondsAgo: 2,
        now: now,
        packageName: 'com.spotify.music',
        sourceLabel: 'Spotify',
        subtype: 'PLAYING',
      ),
    ];

    final result = ScoringEngine().analyze(events, now);

    expect(result.isUnknown, isFalse);
    expect(result.sourceLabel, 'Spotify');
    expect(result.reasons, contains('Spotify is active in background'));
    expect(result.reasons, contains('Notification posted by Spotify'));
    expect(
      result.scoreBreakdown.map((item) => item.label),
      containsAll([
        'Recent notification',
        'Playing media bonus',
      ]),
    );
  });
}
