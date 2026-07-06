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
    expect(result.confidencePercent, greaterThan(50));
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
  });
}
