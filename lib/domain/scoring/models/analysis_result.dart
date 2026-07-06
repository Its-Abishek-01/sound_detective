import '../../../data/models/sound_event.dart';

/// Device-state context attached to a result — never a candidate on its
/// own, just descriptive metadata (matches the "Audio Stream / Screen
/// Off / Foreground: No" style metadata rows in the mockups).
class DeviceStateSnapshot {
  const DeviceStateSnapshot({
    this.screenOn,
    this.dndEnabled,
    this.audioStreamLabel,
    this.foregroundAppPackage,
  });

  final bool? screenOn;
  final bool? dndEnabled;
  final String? audioStreamLabel;
  final String? foregroundAppPackage;
}

/// The outcome of running the scoring engine over an analysis window.
class AnalysisResult {
  const AnalysisResult({
    required this.isUnknown,
    required this.analyzedAt,
    this.sourceLabel,
    this.packageName,
    this.confidence,
    this.reasons = const [],
    this.event,
    this.deviceState = const DeviceStateSnapshot(),
    this.nearbyContextEvents = const [],
  });

  factory AnalysisResult.unknown({
    required DateTime analyzedAt,
    DeviceStateSnapshot deviceState = const DeviceStateSnapshot(),
    List<SoundEvent> nearbyContextEvents = const [],
  }) {
    return AnalysisResult(
      isUnknown: true,
      analyzedAt: analyzedAt,
      deviceState: deviceState,
      nearbyContextEvents: nearbyContextEvents,
    );
  }

  final bool isUnknown;
  final DateTime analyzedAt;
  final String? sourceLabel;
  final String? packageName;

  /// 0.0–[ScoringConfig.maxConfidence]; null when [isUnknown].
  final double? confidence;
  final List<String> reasons;
  final SoundEvent? event;
  final DeviceStateSnapshot deviceState;

  /// Raw Tier A events shown to the user when nothing scored high
  /// enough to be a confident answer.
  final List<SoundEvent> nearbyContextEvents;

  int get confidencePercent => ((confidence ?? 0) * 100).round();
}
