// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_result_dao.dart';

// ignore_for_file: type=lint
mixin _$AnalysisResultDaoMixin on DatabaseAccessor<AppDatabase> {
  $AnalysisResultsTable get analysisResults => attachedDatabase.analysisResults;
  AnalysisResultDaoManager get managers => AnalysisResultDaoManager(this);
}

class AnalysisResultDaoManager {
  final _$AnalysisResultDaoMixin _db;
  AnalysisResultDaoManager(this._db);
  $$AnalysisResultsTableTableManager get analysisResults =>
      $$AnalysisResultsTableTableManager(
        _db.attachedDatabase,
        _db.analysisResults,
      );
}
