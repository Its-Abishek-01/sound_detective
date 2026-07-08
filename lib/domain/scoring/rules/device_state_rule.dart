import '../../../data/models/sound_event.dart';
import '../models/analysis_result.dart';

/// Unlike the other rules, this isn't a per-candidate scorer — it
/// extracts descriptive device-state context (screen, DND, audio
/// route, foreground app) from the whole window to attach to whichever
/// candidate wins, matching the "Audio Stream / Foreground / Device
/// State" metadata rows in the mockups.
class DeviceStateRule {
  DeviceStateRule._();

  static DeviceStateSnapshot extract(List<SoundEvent> allWindowEvents) {
    bool? screenOn;
    bool? dndEnabled;
    String? audioStreamLabel;
    String? foregroundAppPackage;
    String? ringerMode;

    for (final event in allWindowEvents) {
      switch (event.category) {
        case SoundEventCategory.screen:
          screenOn = event.subtype.toUpperCase() == 'ON';
        case SoundEventCategory.dnd:
          dndEnabled = event.subtype.toUpperCase() != 'OFF';
        case SoundEventCategory.audioFocus:
        case SoundEventCategory.audioPlaybackState:
          audioStreamLabel ??= event.metadata['streamType'] as String?;
        case SoundEventCategory.foregroundApp:
          foregroundAppPackage ??= event.packageName;
        case SoundEventCategory.ringer:
          // Events arrive newest-first; keep the most recent mode.
          ringerMode ??= event.subtype;
        default:
          break;
      }
    }

    return DeviceStateSnapshot(
      screenOn: screenOn,
      dndEnabled: dndEnabled,
      audioStreamLabel: audioStreamLabel,
      foregroundAppPackage: foregroundAppPackage,
      ringerMode: ringerMode,
    );
  }
}
