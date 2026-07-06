import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/models/sound_event.dart';

final timelineProvider = StreamProvider<List<SoundEvent>>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.watchTimeline();
});
