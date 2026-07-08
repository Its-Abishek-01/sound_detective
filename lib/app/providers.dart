import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/app_database.dart';
import '../data/repositories/event_repository.dart';
import '../data/repositories/history_repository.dart';
import '../platform/native_bridge.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final nativeBridgeProvider = Provider<NativeBridge>((ref) => NativeBridge());

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final repo = EventRepository(ref.watch(appDatabaseProvider));
  ref.onDispose(repo.dispose);
  return repo;
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(ref.watch(appDatabaseProvider));
});

/// Subscribes to the native event stream once and fans events into the
/// repository. Kept as a provider so it starts as soon as the app's
/// widget tree is built and stops cleanly on dispose.
final eventIngestionProvider = Provider<void>((ref) {
  final bridge = ref.watch(nativeBridgeProvider);
  final repo = ref.watch(eventRepositoryProvider);
  repo.startPruning();
  final sub = bridge.eventStream.listen(repo.recordEvent);
  ref.onDispose(sub.cancel);
});
