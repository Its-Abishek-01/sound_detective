import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../platform/service_status.dart';

/// Live "is the background service actually listening" indicator,
/// straight off the native EventChannel — not persisted, just UI
/// feedback.
final serviceStatusProvider = StreamProvider<ServiceStatus>((ref) {
  final bridge = ref.watch(nativeBridgeProvider);
  return bridge.serviceStatusStream;
});
