import 'dart:convert';

import 'package:drift/drift.dart' show QueryRow, Value;

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

  Future<void> saveFeedback({
    required DateTime analyzedAt,
    required DetectionFeedback feedback,
  }) {
    return _db.analysisResultDao.upsertFeedback(
      analyzedAtMs: analyzedAt.millisecondsSinceEpoch,
      feedback: feedback.wireName,
      updatedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Stream<List<AnalysisResult>> watchHistory({int limit = 100}) {
    return _db.analysisResultDao
        .watchRecentWithFeedback(limit: limit)
        .map((rows) => rows.map(_fromJoinedRow).toList());
  }

  AnalysisResult _fromJoinedRow(QueryRow row) {
    return AnalysisResult(
      isUnknown: row.read<bool>('is_unknown'),
      analyzedAt: DateTime.fromMillisecondsSinceEpoch(
        row.read<int>('analyzed_at_ms'),
      ),
      sourceLabel: row.readNullable<String>('source_label'),
      packageName: row.readNullable<String>('package_name'),
      confidence: row.readNullable<double>('confidence'),
      reasons: (jsonDecode(row.read<String>('reasons_json')) as List)
          .cast<String>(),
      feedback: DetectionFeedbackWire.fromWire(
        row.readNullable<String>('user_feedback'),
      ),
      deviceState: DeviceStateSnapshot(
        ringerMode: row.readNullable<String>('ringer_mode'),
        screenOn: row.readNullable<bool>('screen_on'),
        audioStreamLabel: row.readNullable<String>('audio_stream_label'),
      ),
    );
  }
}
