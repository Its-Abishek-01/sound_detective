import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/analysis_result_table.dart';

part 'analysis_result_dao.g.dart';

@DriftAccessor(tables: [AnalysisResults])
class AnalysisResultDao extends DatabaseAccessor<AppDatabase>
    with _$AnalysisResultDaoMixin {
  AnalysisResultDao(super.db);

  Future<void> insertResult(AnalysisResultsCompanion entry) {
    return into(analysisResults).insert(entry);
  }

  Future<void> upsertFeedback({
    required int analyzedAtMs,
    required String feedback,
    required int updatedAtMs,
  }) {
    return attachedDatabase.customStatement(
      'INSERT INTO analysis_feedback '
      '(analyzed_at_ms, feedback, updated_at_ms) '
      'VALUES (?, ?, ?) '
      'ON CONFLICT(analyzed_at_ms) DO UPDATE SET '
      'feedback = excluded.feedback, '
      'updated_at_ms = excluded.updated_at_ms;',
      [analyzedAtMs, feedback, updatedAtMs],
    );
  }

  Stream<List<AnalysisResultRow>> watchRecent({int limit = 100}) {
    return (select(analysisResults)
          ..orderBy([(t) => OrderingTerm.desc(t.analyzedAtMs)])
          ..limit(limit))
        .watch();
  }

  Stream<List<QueryRow>> watchRecentWithFeedback({int limit = 100}) {
    return attachedDatabase
        .customSelect(
          'SELECT '
          'ar.id, '
          'ar.analyzed_at_ms, '
          'ar.is_unknown, '
          'ar.source_label, '
          'ar.package_name, '
          'ar.confidence, '
          'ar.reasons_json, '
          'ar.ringer_mode, '
          'ar.screen_on, '
          'ar.audio_stream_label, '
          'af.feedback AS user_feedback '
          'FROM analysis_results ar '
          'LEFT JOIN analysis_feedback af '
          'ON af.analyzed_at_ms = ar.analyzed_at_ms '
          'ORDER BY ar.analyzed_at_ms DESC '
          'LIMIT ?;',
          variables: [Variable<int>(limit)],
          readsFrom: {analysisResults},
        )
        .watch();
  }

  Future<int> deleteOlderThan(int cutoffMs) {
    return (delete(analysisResults)
          ..where((t) => t.analyzedAtMs.isSmallerThanValue(cutoffMs)))
        .go();
  }
}
