import 'dart:async';

import 'package:drift/drift.dart' show Value;

import '../local/app_database.dart';
import '../models/sound_event.dart';

/// Bridges native events (delivered via [SoundEvent] instances read off
/// the platform EventChannel by [NativeBridge]) into the local Drift
/// database, and prunes old rows on a rolling window.
///
/// Native is never a second source of truth for persisted history: it
/// only publishes events, this repository is the sole writer to the DB.
class EventRepository {
  EventRepository(this._db, {Duration retention = const Duration(hours: 24)})
      : _retention = retention;

  final AppDatabase _db;
  final Duration _retention;
  Timer? _pruneTimer;

  static const _pruneInterval = Duration(minutes: 10);

  void startPruning() {
    _pruneTimer?.cancel();
    _pruneTimer = Timer.periodic(_pruneInterval, (_) => pruneOldEvents());
    // Run once immediately so a long-idle app doesn't wait 10 minutes.
    unawaited(pruneOldEvents());
  }

  void dispose() {
    _pruneTimer?.cancel();
    _pruneTimer = null;
  }

  Future<void> pruneOldEvents() async {
    final cutoff = DateTime.now().subtract(_retention).millisecondsSinceEpoch;
    await _db.eventDao.deleteOlderThan(cutoff);
  }

  Future<void> recordEvent(SoundEvent event) {
    return _db.eventDao.insertEvent(
      EventsCompanion.insert(
        id: event.id,
        timestampMs: event.timestampMs,
        category: event.category.wireName,
        tier: event.tier.wireName,
        subtype: Value(event.subtype),
        sourceLabel: Value(event.sourceLabel),
        packageName: Value(event.packageName),
        appName: Value(event.appName),
        metadataJson: Value(event.metadataJson),
        confidenceWeight: Value(event.confidenceWeight),
      ),
    );
  }

  /// Events at or after [sinceMs], newest first — used by the scoring
  /// engine to pull the analysis window (e.g. the last 30 seconds).
  Future<List<SoundEvent>> eventsSince(int sinceMs) async {
    final rows = await _db.eventDao.eventsSince(sinceMs);
    return rows.map(_fromRow).toList();
  }

  /// Reactive stream of the recent timeline for the browsing UI.
  Stream<List<SoundEvent>> watchTimeline({int limit = 500}) {
    return _db.eventDao
        .watchRecentEvents(limit: limit)
        .map((rows) => rows.map(_fromRow).toList());
  }

  SoundEvent _fromRow(Event row) {
    return SoundEvent.fromDb(
      id: row.id,
      timestampMs: row.timestampMs,
      category: row.category,
      tier: row.tier,
      subtype: row.subtype,
      sourceLabel: row.sourceLabel,
      packageName: row.packageName,
      appName: row.appName,
      metadataJson: row.metadataJson,
      confidenceWeight: row.confidenceWeight,
    );
  }
}
