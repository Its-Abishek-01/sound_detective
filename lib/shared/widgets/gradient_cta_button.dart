import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The single fully-opaque element in an otherwise all-glass UI. A
/// pure glass button would have poor tap affordance for the app's one
/// critical action, so the primary CTA gets a solid gradient + glow
/// instead while everything else stays translucent.
class GradientCtaButton extends StatelessWidget {
  const GradientCtaButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = 220,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.ctaStart, AppColors.ctaEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ctaEnd.withValues(alpha: 0.45),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(child: child),
        ),
      ),
    );
  }
}
