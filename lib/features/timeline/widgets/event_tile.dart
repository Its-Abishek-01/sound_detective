import 'package:flutter/material.dart';

import '../../../data/models/sound_event.dart';

IconData _iconFor(SoundEventCategory category) {
  switch (category) {
    case SoundEventCategory.battery:
      return Icons.battery_charging_full;
    case SoundEventCategory.headphones:
      return Icons.headphones;
    case SoundEventCategory.bluetooth:
      return Icons.bluetooth;
    case SoundEventCategory.usb:
      return Icons.usb;
    case SoundEventCategory.wifi:
      return Icons.wifi;
    case SoundEventCategory.mobileNetwork:
      return Icons.signal_cellular_alt;
    case SoundEventCategory.screen:
      return Icons.smartphone;
    case SoundEventCategory.rotation:
      return Icons.screen_rotation;
    case SoundEventCategory.volume:
      return Icons.volume_up;
    case SoundEventCategory.dnd:
      return Icons.do_not_disturb_on;
    case SoundEventCategory.alarmClock:
      return Icons.alarm;
    case SoundEventCategory.notificationPosted:
    case SoundEventCategory.notificationRemoved:
      return Icons.notifications;
    case SoundEventCategory.mediaSession:
      return Icons.music_note;
    case SoundEventCategory.audioFocus:
    case SoundEventCategory.audioPlaybackState:
      return Icons.graphic_eq;
    case SoundEventCategory.foregroundApp:
      return Icons.apps;
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
    return ListTile(
      leading: Icon(_iconFor(event.category)),
      title: Text(event.sourceLabel.isEmpty ? event.category.wireName : event.sourceLabel),
      subtitle: Text(event.subtype),
      trailing: Text(
        _formatTime(event.timestamp),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
