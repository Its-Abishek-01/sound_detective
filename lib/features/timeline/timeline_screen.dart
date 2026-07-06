import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'timeline_controller.dart';
import 'widgets/event_tile.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(timelineProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Timeline')),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Could not load timeline: $err')),
        data: (events) {
          if (events.isEmpty) {
            return const Center(child: Text('No activity recorded yet.'));
          }
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final showDateHeader = index == 0 ||
                  !_isSameDay(events[index - 1].timestamp, event.timestamp);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showDateHeader)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Text(
                        _formatDateHeader(event.timestamp),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  EventTile(event: event),
                  const Divider(height: 1),
                ],
              );
            },
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatDateHeader(DateTime time) {
    final now = DateTime.now();
    if (_isSameDay(time, now)) return 'Today';
    final yesterday = now.subtract(const Duration(days: 1));
    if (_isSameDay(time, yesterday)) return 'Yesterday';
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
  }
}
