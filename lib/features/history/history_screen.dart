import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/scoring/models/analysis_result.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/widgets/glass_container.dart';
import '../../shared/widgets/glass_scaffold.dart';
import 'history_controller.dart';

/// Past Detective Mode answers, newest first — the "what did it say
/// last time" companion to the raw-event Timeline.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return GlassScaffold(
      title: 'Past results',
      body: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight + AppSpacing.sm),
        child: historyAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.blobCyan),
          ),
          error: (err, _) => Center(
            child: Text(
              'Could not load history: $err',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          data: (results) {
            if (results.isEmpty) {
              return const Center(
                child: Text(
                  'No detections yet — tap the big button when\n'
                  'you hear a mysterious sound.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textTertiary),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: results.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) =>
                  _HistoryCard(result: results[index]),
            );
          },
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.result});

  final AnalysisResult result;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                result.isUnknown
                    ? Icons.help_outline_rounded
                    : Icons.verified_rounded,
                size: 20,
                color: result.isUnknown
                    ? AppColors.warning
                    : AppColors.success,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  result.isUnknown
                      ? 'Unknown'
                      : result.sourceLabel ?? 'Unknown',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (!result.isUnknown)
                Text(
                  '${result.confidencePercent}%',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _formatTimestamp(result.analyzedAt),
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
            ),
          ),
          if (result.reasons.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            for (final reason in result.reasons)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '• $reason',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour < 12 ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    final clock = '$hour12:$minute $period';

    final isToday = time.year == now.year &&
        time.month == now.month &&
        time.day == now.day;
    if (isToday) return 'Today, $clock';
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = time.year == yesterday.year &&
        time.month == yesterday.month &&
        time.day == yesterday.day;
    if (isYesterday) return 'Yesterday, $clock';
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-'
        '${time.day.toString().padLeft(2, '0')}, $clock';
  }
}
