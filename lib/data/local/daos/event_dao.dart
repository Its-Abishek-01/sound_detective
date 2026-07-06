import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/event_table.dart';

part 'event_dao.g.dart';

@DriftAccessor(tables: [Events])
class EventDao extends DatabaseAccessor<AppDatabase> with _$EventDaoMixin {
  EventDao(super.db);

  Future<void> insertEvent(EventsCompanion entry) {
    return into(events).insertOnConflictUpdate(entry);
  }

  /// All events with `timestampMs >= sinceMs`, newest first.
  Future<List<Event>> eventsSince(int sinceMs) {
    return (select(events)
          ..where((t) => t.timestampMs.isBiggerOrEqualValue(sinceMs))
          ..orderBy([(t) => OrderingTerm.desc(t.timestampMs)]))
        .get();
  }

  /// Reactive stream of the full timeline, newest first, capped at
  /// [limit] rows for the browsing UI.
  Stream<List<Event>> watchRecentEvents({int limit = 500}) {
    return (select(events)
          ..orderBy([(t) => OrderingTerm.desc(t.timestampMs)])
          ..limit(limit))
        .watch();
  }

  Future<int> deleteOlderThan(int cutoffMs) {
    return (delete(events)
          ..where((t) => t.timestampMs.isSmallerThanValue(cutoffMs)))
        .go();
  }
}
