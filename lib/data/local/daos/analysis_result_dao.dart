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

  Stream<List<AnalysisResultRow>> watchRecent({int limit = 100}) {
    return (select(analysisResults)
          ..orderBy([(t) => OrderingTerm.desc(t.analyzedAtMs)])
          ..limit(limit))
        .watch();
  }

  Future<int> deleteOlderThan(int cutoffMs) {
    return (delete(analysisResults)
          ..where((t) => t.analyzedAtMs.isSmallerThanValue(cutoffMs)))
        .go();
  }
}
