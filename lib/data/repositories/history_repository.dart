import 'dart:convert';

import 'package:drift/drift.dart' show Value;

import '../../domain/scoring/models/analysis_result.dart';
import '../local/app_database.dart';

/// Persists Detective Mode answers and replays them for the History
/// screen. Results are kept much longer than raw events (they're tiny
/// and they're the part users actually want to look back on).
class HistoryRepository {
  HistoryRepository(this._db, {Duration retention = const Duration(days: 90)})
      : _retention = retention;

  final AppDatabase _db;
  final Duration _retention;

  Future<void> saveResult(AnalysisResult result) async {
    await _db.analysisResultDao.insertResult(
      AnalysisResultsCompanion.insert(
        analyzedAtMs: result.analyzedAt.millisecondsSinceEpoch,
        isUnknown: result.isUnknown,
        sourceLabel: Value(result.sourceLabel),
        packageName: Value(result.packageName),
        confidence: Value(result.confidence),
        reasonsJson: Value(jsonEncode(result.reasons)),
        ringerMode: Value(result.deviceState.ringerMode),
        screenOn: Value(result.deviceState.screenOn),
        audioStreamLabel: Value(result.deviceState.audioStreamLabel),
      ),
    );
    // Cheap opportunistic prune — history writes are rare (one per
    // button press), so no periodic timer is warranted.
    await _db.analysisResultDao.deleteOlderThan(
      DateTime.now().subtract(_retention).millisecondsSinceEpoch,
    );
  }

  Stream<List<AnalysisResult>> watchHistory({int limit = 100}) {
    return _db.analysisResultDao
        .watchRecent(limit: limit)
        .map((rows) => rows.map(_fromRow).toList());
  }

  AnalysisResult _fromRow(AnalysisResultRow row) {
    return AnalysisResult(
      isUnknown: row.isUnknown,
      analyzedAt: DateTime.fromMillisecondsSinceEpoch(row.analyzedAtMs),
      sourceLabel: row.sourceLabel,
      packageName: row.packageName,
      confidence: row.confidence,
      reasons: (jsonDecode(row.reasonsJson) as List).cast<String>(),
      deviceState: DeviceStateSnapshot(
        ringerMode: row.ringerMode,
        screenOn: row.screenOn,
        audioStreamLabel: row.audioStreamLabel,
      ),
    );
  }
}
