import 'package:drift/drift.dart';

/// One row per Detective Mode run — the *answers* history, as opposed
/// to the raw `events` timeline. Kept separately so pruning the
/// short-retention event log never erases past results.
/// Row class renamed to avoid colliding with the domain AnalysisResult.
@DataClassName('AnalysisResultRow')
class AnalysisResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get analyzedAtMs => integer()();
  BoolColumn get isUnknown => boolean()();
  TextColumn get sourceLabel => text().nullable()();
  TextColumn get packageName => text().nullable()();
  RealColumn get confidence => real().nullable()();

  /// JSON-encoded list of reason strings.
  TextColumn get reasonsJson => text().withDefault(const Constant('[]'))();
  TextColumn get ringerMode => text().nullable()();
  BoolColumn get screenOn => boolean().nullable()();
  TextColumn get audioStreamLabel => text().nullable()();
}
