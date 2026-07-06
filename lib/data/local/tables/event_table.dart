import 'package:drift/drift.dart';

/// Single rolling-window event log. All query patterns are time-range
/// scans (`WHERE timestamp_ms > ?`) and batch pruning
/// (`DELETE WHERE timestamp_ms < ?`), so a single indexed table is the
/// right shape rather than per-category tables.
class Events extends Table {
  TextColumn get id => text()();
  IntColumn get timestampMs => integer()();
  TextColumn get category => text()();
  TextColumn get tier => text()();
  TextColumn get subtype => text().withDefault(const Constant(''))();
  TextColumn get sourceLabel => text().withDefault(const Constant(''))();
  TextColumn get packageName => text().nullable()();
  TextColumn get appName => text().nullable()();
  TextColumn get metadataJson => text().withDefault(const Constant('{}'))();
  RealColumn get confidenceWeight => real().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
