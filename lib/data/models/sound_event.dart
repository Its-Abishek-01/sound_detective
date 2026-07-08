import 'dart:convert';

/// Which permission tier produced this event. Mirrors the product's
/// Tier A/B/C data-source split.
enum SoundEventTier { a, b, c }

/// The category of OS signal this event represents. Kept flat (not
/// nested) so it maps 1:1 to a single Kotlin enum and a single Drift
/// text column.
enum SoundEventCategory {
  battery,
  headphones,
  bluetooth,
  usb,
  wifi,
  mobileNetwork,
  screen,
  rotation,
  volume,
  dnd,
  ringer,
  alarmClock,
  notificationPosted,
  notificationRemoved,
  mediaSession,
  audioFocus,
  audioPlaybackState,
  foregroundApp,
}

SoundEventCategory _categoryFromWire(String value) {
  return SoundEventCategory.values.firstWhere(
    (c) => c.wireName == value,
    orElse: () => throw ArgumentError('Unknown SoundEventCategory: $value'),
  );
}

extension SoundEventCategoryWire on SoundEventCategory {
  /// SCREAMING_SNAKE_CASE wire form shared with the Kotlin side.
  String get wireName {
    switch (this) {
      case SoundEventCategory.battery:
        return 'BATTERY';
      case SoundEventCategory.headphones:
        return 'HEADPHONES';
      case SoundEventCategory.bluetooth:
        return 'BLUETOOTH';
      case SoundEventCategory.usb:
        return 'USB';
      case SoundEventCategory.wifi:
        return 'WIFI';
      case SoundEventCategory.mobileNetwork:
        return 'MOBILE_NETWORK';
      case SoundEventCategory.screen:
        return 'SCREEN';
      case SoundEventCategory.rotation:
        return 'ROTATION';
      case SoundEventCategory.volume:
        return 'VOLUME';
      case SoundEventCategory.dnd:
        return 'DND';
      case SoundEventCategory.ringer:
        return 'RINGER';
      case SoundEventCategory.alarmClock:
        return 'ALARM_CLOCK';
      case SoundEventCategory.notificationPosted:
        return 'NOTIFICATION_POSTED';
      case SoundEventCategory.notificationRemoved:
        return 'NOTIFICATION_REMOVED';
      case SoundEventCategory.mediaSession:
        return 'MEDIA_SESSION';
      case SoundEventCategory.audioFocus:
        return 'AUDIO_FOCUS';
      case SoundEventCategory.audioPlaybackState:
        return 'AUDIO_PLAYBACK_STATE';
      case SoundEventCategory.foregroundApp:
        return 'FOREGROUND_APP';
    }
  }
}

extension SoundEventTierWire on SoundEventTier {
  String get wireName {
    switch (this) {
      case SoundEventTier.a:
        return 'A';
      case SoundEventTier.b:
        return 'B';
      case SoundEventTier.c:
        return 'C';
    }
  }
}

SoundEventTier _tierFromWire(String value) {
  return SoundEventTier.values.firstWhere(
    (t) => t.wireName == value,
    orElse: () => throw ArgumentError('Unknown SoundEventTier: $value'),
  );
}

/// The single unified event shape that flows from native collectors,
/// across the platform channel, into storage, and into the scoring
/// engine. Heterogeneous per-category payloads live in [metadata]
/// rather than as dedicated columns/fields.
class SoundEvent {
  const SoundEvent({
    required this.id,
    required this.timestampMs,
    required this.category,
    required this.tier,
    required this.subtype,
    required this.sourceLabel,
    this.packageName,
    this.appName,
    this.metadata = const {},
    this.confidenceWeight = 0,
  });

  final String id;
  final int timestampMs;
  final SoundEventCategory category;
  final SoundEventTier tier;

  /// A category-specific discriminator, e.g. "CONNECTED" / "DISCONNECTED"
  /// for bluetooth, or "PLAYING" / "PAUSED" for media sessions.
  final String subtype;

  /// Human-readable label for display, e.g. "WhatsApp" or "Bluetooth".
  final String sourceLabel;

  final String? packageName;
  final String? appName;
  final Map<String, dynamic> metadata;
  final double confidenceWeight;

  DateTime get timestamp =>
      DateTime.fromMillisecondsSinceEpoch(timestampMs, isUtc: false);

  factory SoundEvent.fromChannelMap(Map<dynamic, dynamic> map) {
    final rawMetadata = map['metadataJson'] as String?;
    return SoundEvent(
      id: map['id'] as String,
      timestampMs: map['timestampMs'] as int,
      category: _categoryFromWire(map['category'] as String),
      tier: _tierFromWire(map['tier'] as String),
      subtype: map['subtype'] as String? ?? '',
      sourceLabel: map['sourceLabel'] as String? ?? '',
      packageName: map['packageName'] as String?,
      appName: map['appName'] as String?,
      metadata: rawMetadata == null || rawMetadata.isEmpty
          ? const {}
          : jsonDecode(rawMetadata) as Map<String, dynamic>,
      confidenceWeight: (map['confidenceWeight'] as num?)?.toDouble() ?? 0,
    );
  }

  factory SoundEvent.fromDb({
    required String id,
    required int timestampMs,
    required String category,
    required String tier,
    required String subtype,
    required String sourceLabel,
    String? packageName,
    String? appName,
    required String metadataJson,
    required double confidenceWeight,
  }) {
    return SoundEvent(
      id: id,
      timestampMs: timestampMs,
      category: _categoryFromWire(category),
      tier: _tierFromWire(tier),
      subtype: subtype,
      sourceLabel: sourceLabel,
      packageName: packageName,
      appName: appName,
      metadata: metadataJson.isEmpty
          ? const {}
          : jsonDecode(metadataJson) as Map<String, dynamic>,
      confidenceWeight: confidenceWeight,
    );
  }

  String get metadataJson => jsonEncode(metadata);
}
