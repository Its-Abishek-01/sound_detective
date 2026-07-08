import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/sound_event.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/widgets/glass_container.dart';
import '../../shared/widgets/glass_scaffold.dart';
import 'timeline_controller.dart';
import 'widgets/event_tile.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(timelineProvider);

    return GlassScaffold(
      title: 'Timeline',
      body: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight + AppSpacing.sm),
        child: eventsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.blobCyan),
          ),
          error: (err, _) => Center(
            child: Text(
              'Could not load timeline: $err',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          data: (events) {
            if (events.isEmpty) {
              return const Center(
                child: Text(
                  'No activity recorded yet.',
                  style: TextStyle(color: AppColors.textTertiary),
                ),
              );
            }
            final groups = _groupByDay(events);
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: AppSpacing.xs,
                          bottom: AppSpacing.sm,
                        ),
                        child: Text(
                          group.label,
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      GlassContainer(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        child: Column(
                          children: [
                            for (var i = 0; i < group.events.length; i++) ...[
                              EventTile(event: group.events[i]),
                              if (i != group.events.length - 1)
                                const Divider(height: 1, indent: AppSpacing.md, endIndent: AppSpacing.md),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<_DayGroup> _groupByDay(List<SoundEvent> events) {
    final now = DateTime.now();
    final groups = <_DayGroup>[];
    for (final event in events) {
      final t = event.timestamp;
      final label = _isSameDay(t, now)
          ? 'Today'
          : _isSameDay(t, now.subtract(const Duration(days: 1)))
          ? 'Yesterday'
          : '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';

      if (groups.isNotEmpty && groups.last.label == label) {
        groups.last.events.add(event);
      } else {
        groups.add(_DayGroup(label: label, events: [event]));
      }
    }
    return groups;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayGroup {
  _DayGroup({required this.label, required this.events});

  final String label;
  final List<SoundEvent> events;
}
