import 'package:flutter/material.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/widgets/glass_container.dart';

class PermissionStepWidget extends StatelessWidget {
  const PermissionStepWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.granted,
    required this.grantButtonLabel,
    required this.onGrant,
    required this.onContinue,
    this.optional = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool granted;
  final String grantButtonLabel;
  final VoidCallback onGrant;
  final VoidCallback onContinue;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GlassContainer(
        strong: true,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.glassFillStrong,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Icon(icon, size: 32, color: AppColors.blobCyan),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            if (granted)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Text(
                    'Granted',
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onGrant,
                  child: Text(grantButtonLabel),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            if (granted)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onContinue,
                  child: const Text('Continue'),
                ),
              )
            else if (optional)
              TextButton(onPressed: onContinue, child: const Text('Skip')),
          ],
        ),
      ),
    );
  }
}
