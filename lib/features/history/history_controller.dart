import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/scoring/models/analysis_result.dart';

final historyProvider = StreamProvider<List<AnalysisResult>>((ref) {
  return ref.watch(historyRepositoryProvider).watchHistory();
});
