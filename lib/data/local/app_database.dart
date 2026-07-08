import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/analysis_result_dao.dart';
import 'daos/event_dao.dart';
import 'tables/analysis_result_table.dart';
import 'tables/event_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Events, AnalysisResults],
  daos: [EventDao, AnalysisResultDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_events_timestamp '
            'ON events(timestamp_ms);',
          );
          await _createAnalysisFeedbackTable();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(analysisResults);
          }
          if (from < 3) {
            await _createAnalysisFeedbackTable();
          }
        },
      );

  Future<void> _createAnalysisFeedbackTable() {
    return customStatement(
      'CREATE TABLE IF NOT EXISTS analysis_feedback ('
      'analyzed_at_ms INTEGER PRIMARY KEY NOT NULL, '
      'feedback TEXT NOT NULL, '
      'updated_at_ms INTEGER NOT NULL'
      ');',
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'sound_detective.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
