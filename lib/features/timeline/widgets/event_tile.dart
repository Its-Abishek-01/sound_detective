import 'package:flutter/material.dart';

import '../../../data/models/sound_event.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';

IconData _iconFor(SoundEventCategory category) {
  switch (category) {
    case SoundEventCategory.battery:
      return Icons.battery_charging_full_rounded;
    case SoundEventCategory.headphones:
      return Icons.headphones_rounded;
    case SoundEventCategory.bluetooth:
      return Icons.bluetooth_rounded;
    case SoundEventCategory.usb:
      return Icons.usb_rounded;
    case SoundEventCategory.wifi:
      return Icons.wifi_rounded;
    case SoundEventCategory.mobileNetwork:
      return Icons.signal_cellular_alt_rounded;
    case SoundEventCategory.screen:
      return Icons.smartphone_rounded;
    case SoundEventCategory.rotation:
      return Icons.screen_rotation_rounded;
    case SoundEventCategory.volume:
      return Icons.volume_up_rounded;
    case SoundEventCategory.dnd:
      return Icons.do_not_disturb_on_rounded;
    case SoundEventCategory.ringer:
      return Icons.vibration_rounded;
    case SoundEventCategory.alarmClock:
      return Icons.alarm_rounded;
    case SoundEventCategory.notificationPosted:
    case SoundEventCategory.notificationRemoved:
      return Icons.notifications_rounded;
    case SoundEventCategory.mediaSession:
      return Icons.music_note_rounded;
    case SoundEventCategory.audioFocus:
    case SoundEventCategory.audioPlaybackState:
      return Icons.graphic_eq_rounded;
    case SoundEventCategory.foregroundApp:
      return Icons.apps_rounded;
  }
}

String _formatTime(DateTime time) {
  final hour24 = time.hour;
  final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
  final period = hour24 < 12 ? 'AM' : 'PM';
  final minute = time.minute.toString().padLeft(2, '0');
  final second = time.second.toString().padLeft(2, '0');
  return '$hour12:$minute:$second $period';
}

class EventTile extends StatelessWidget {
  const EventTile({super.key, required this.event});

  final SoundEvent event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.glassFillStrong,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Icon(
              _iconFor(event.category),
              size: 20,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.sourceLabel.isEmpty
                      ? event.category.wireName
                      : event.sourceLabel,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (event.subtype.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      event.subtype,
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            _formatTime(event.timestamp),
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
